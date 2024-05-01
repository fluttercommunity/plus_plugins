// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.androidalarmmanager;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.AssetManager;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.FlutterInjector;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.embedding.engine.dart.DartExecutor.DartCallback;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.view.FlutterCallbackInformation;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicBoolean;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * An background execution abstraction which handles initializing a background isolate running a
 * callback dispatcher, used to invoke Dart callbacks while backgrounded.
 */
public class FlutterBackgroundExecutor implements MethodCallHandler {
  private static final String TAG = "FlutterBackgroundExecutor";
  private static final String CALLBACK_HANDLE_KEY = "callback_handle";

  /**
   * The {@link MethodChannel} that connects the Android side of this plugin with the background
   * Dart isolate that was created by this plugin.
   */
  private MethodChannel backgroundChannel;

  private FlutterEngine backgroundFlutterEngine;

  private final AtomicBoolean isCallbackDispatcherReady = new AtomicBoolean(false);

  /**
   * Sets the Dart callback handle for the Dart method that is responsible for initializing the
   * background Dart isolate, preparing it to receive Dart callback tasks requests.
   */
  public static void setCallbackDispatcher(Context context, long callbackHandle) {
    SharedPreferences prefs = context.getSharedPreferences(AlarmService.SHARED_PREFERENCES_KEY, 0);
    prefs.edit().putLong(CALLBACK_HANDLE_KEY, callbackHandle).apply();
  }

  /** Returns true when the background isolate has started and is ready to handle alarms. */
  public boolean isRunning() {
    return isCallbackDispatcherReady.get();
  }

  private void onInitialized() {
    isCallbackDispatcherReady.set(true);
    AlarmService.onInitialized();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String method = call.method;
    Object arguments = call.arguments;
    try {
      if (method.equals("AlarmService.initialized")) {
        // This message is sent by the background method channel as soon as the background isolate
        // is running. From this point forward, the Android side of this plugin can send
        // callback handles through the background method channel, and the Dart side will execute
        // the Dart methods corresponding to those callback handles.
        onInitialized();
        result.success(true);
      } else {
        result.notImplemented();
      }
    } catch (PluginRegistrantException e) {
      result.error("error", "AlarmManager error: " + e.getMessage(), null);
    }
  }

  /**
   * Starts running a background Dart isolate within a new {@link FlutterEngine} using a previously
   * used entrypoint.
   *
   * <p>The isolate is configured as follows:
   *
   * <ul>
   *   <li>Bundle Path: {@code FlutterMain.findAppBundlePath(context)}.
   *   <li>Entrypoint: The Dart method used the last time this plugin was initialized in the
   *       foreground.
   *   <li>Run args: none.
   * </ul>
   *
   * <p>Preconditions:
   *
   * <ul>
   *   <li>The given callback must correspond to a registered Dart callback. If the handle does not
   *       resolve to a Dart callback then this method does nothing.
   * </ul>
   */
  public void startBackgroundIsolate(Context context) {
    if (!isRunning()) {
      SharedPreferences p = context.getSharedPreferences(AlarmService.SHARED_PREFERENCES_KEY, 0);
      long callbackHandle = p.getLong(CALLBACK_HANDLE_KEY, 0);
      startBackgroundIsolate(context, callbackHandle);
    }
  }

  /**
   * Starts running a background Dart isolate within a new {@link FlutterEngine}.
   *
   * <p>The isolate is configured as follows:
   *
   * <ul>
   *   <li>Bundle Path: {@code FlutterMain.findAppBundlePath(context)}.
   *   <li>Entrypoint: The Dart method represented by {@code callbackHandle}.
   *   <li>Run args: none.
   * </ul>
   *
   * <p>Preconditions:
   *
   * <ul>
   *   <li>The given {@code callbackHandle} must correspond to a registered Dart callback. If the
   *       handle does not resolve to a Dart callback then this method does nothing.
   * </ul>
   */
  public void startBackgroundIsolate(Context context, long callbackHandle) {
    if (backgroundFlutterEngine != null) {
      Log.e(TAG, "Background isolate already started");
      return;
    }

    Log.i(TAG, "Starting AlarmService...");
    if (!isRunning()) {
      backgroundFlutterEngine = new FlutterEngine(context);

      String appBundlePath = FlutterInjector.instance().flutterLoader().findAppBundlePath();
      AssetManager assets = context.getAssets();

      // We need to create an instance of `FlutterEngine` before looking up the
      // callback. If we don't, the callback cache won't be initialized and the
      // lookup will fail.
      FlutterCallbackInformation flutterCallback =
          FlutterCallbackInformation.lookupCallbackInformation(callbackHandle);
      if (flutterCallback == null) {
        Log.e(TAG, "Fatal: failed to find callback");
        return;
      }

      DartExecutor executor = backgroundFlutterEngine.getDartExecutor();
      initializeMethodChannel(executor);
      DartCallback dartCallback = new DartCallback(assets, appBundlePath, flutterCallback);

      executor.executeDartCallback(dartCallback);
    }
  }

  /**
   * Executes the desired Dart callback in a background Dart isolate.
   *
   * <p>The given {@code intent} should contain a {@code long} extra called "callbackHandle", which
   * corresponds to a callback registered with the Dart VM.
   */
  public void executeDartCallbackInBackgroundIsolate(Intent intent, final CountDownLatch latch) {
    // Grab the handle for the callback associated with this alarm. Pay close
    // attention to the type of the callback handle as storing this value in a
    // variable of the wrong size will cause the callback lookup to fail.
    long callbackHandle = intent.getLongExtra("callbackHandle", 0);
    String paramsJsonString = intent.getStringExtra("params");
    JSONObject params = null;
    if (!TextUtils.isEmpty(paramsJsonString)) {
      try {
        params = new JSONObject(paramsJsonString);
      } catch (JSONException e) {
        throw new IllegalArgumentException("Can not convert 'params' to JsonObject", e);
      }
    }
    // If another thread is waiting, then wake that thread when the callback returns a result.
    MethodChannel.Result result = null;
    if (latch != null) {
      result =
          new MethodChannel.Result() {
            @Override
            public void success(Object result) {
              latch.countDown();
            }

            @Override
            public void error(String errorCode, String errorMessage, Object errorDetails) {
              latch.countDown();
            }

            @Override
            public void notImplemented() {
              latch.countDown();
            }
          };
    }

    // Handle the alarm event in Dart. Note that for this plugin, we don't
    // care about the method name as we simply lookup and invoke the callback
    // provided.
    backgroundChannel.invokeMethod(
        "invokeAlarmManagerCallback",
        new Object[] {callbackHandle, intent.getIntExtra("id", -1), params},
        result);
  }

  private void initializeMethodChannel(BinaryMessenger isolate) {
    // backgroundChannel is the channel responsible for receiving the following messages from
    // the background isolate that was setup by this plugin:
    // - "AlarmService.initialized"
    //
    // This channel is also responsible for sending requests from Android to Dart to execute Dart
    // callbacks in the background isolate.
    backgroundChannel =
        new MethodChannel(
            isolate,
            "dev.fluttercommunity.plus/android_alarm_manager_background",
            JSONMethodCodec.INSTANCE);
    backgroundChannel.setMethodCallHandler(this);
  }
}
