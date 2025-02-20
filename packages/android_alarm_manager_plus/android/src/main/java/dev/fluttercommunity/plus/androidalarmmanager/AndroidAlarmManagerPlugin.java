// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.androidalarmmanager;

import android.content.Context;
import android.util.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.JSONMethodCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Flutter plugin for running one-shot and periodic tasks sometime in the future on Android.
 *
 * <p>Plugin initialization goes through these steps:
 *
 * <ol>
 *   <li>Flutter app instructs this plugin to initialize() on the Dart side.
 *   <li>The Dart side of this plugin sends the Android side a "AlarmService.start" message, along
 *       with a Dart callback handle for a Dart callback that should be immediately invoked by a
 *       background Dart isolate.
 *   <li>The Android side of this plugin spins up a background {@link FlutterEngine} to run a
 *       background Dart isolate.
 *   <li>The Android side of this plugin instructs the new background Dart isolate to execute the
 *       callback that was received in the "AlarmService.start" message.
 *   <li>The Dart side of this plugin, running within the new background isolate, executes the
 *       designated callback. This callback prepares the background isolate to then execute any
 *       given Dart callback from that point forward. Thus, at this moment the plugin is fully
 *       initialized and ready to execute arbitrary Dart tasks in the background. The Dart side of
 *       this plugin sends the Android side a "AlarmService.initialized" message to signify that the
 *       Dart is ready to execute tasks.
 * </ol>
 */
public class AndroidAlarmManagerPlugin implements FlutterPlugin, MethodCallHandler {
  private static final String TAG = "AndroidAlarmManagerPlugin";
  private Context context;
  private final Object initializationLock = new Object();
  private MethodChannel alarmManagerPluginChannel;

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  public void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    synchronized (initializationLock) {
      if (alarmManagerPluginChannel != null) {
        return;
      }

      Log.i(TAG, "onAttachedToEngine");
      this.context = applicationContext;

      // alarmManagerPluginChannel is the channel responsible for receiving the following messages
      // from the main Flutter app:
      // - "AlarmService.start"
      // - "Alarm.oneShotAt"
      // - "Alarm.periodic"
      // - "Alarm.cancel"
      alarmManagerPluginChannel =
          new MethodChannel(
              messenger,
              "dev.fluttercommunity.plus/android_alarm_manager",
              JSONMethodCodec.INSTANCE);

      // Instantiate a new AndroidAlarmManagerPlugin and connect the primary method channel for
      // Android/Flutter communication.
      alarmManagerPluginChannel.setMethodCallHandler(this);
    }
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    Log.i(TAG, "onDetachedFromEngine");
    context = null;
    alarmManagerPluginChannel.setMethodCallHandler(null);
    alarmManagerPluginChannel = null;
  }

  public AndroidAlarmManagerPlugin() {}

  /** Invoked when the Flutter side of this plugin sends a message to the Android side. */
  @Override
  public void onMethodCall(MethodCall call, Result result) {
    String method = call.method;
    Object arguments = call.arguments;
    try {
      switch (method) {
        case "AlarmService.start":
          // This message is sent when the Dart side of this plugin is told to initialize.
          long callbackHandle = ((JSONArray) arguments).getLong(0);
          // In response, this (native) side of the plugin needs to spin up a background
          // Dart isolate by using the given callbackHandle, and then setup a background
          // method channel to communicate with the new background isolate. Once completed,
          // this onMethodCall() method will receive messages from both the primary and background
          // method channels.
          AlarmService.setCallbackDispatcher(context, callbackHandle);
          AlarmService.startBackgroundIsolate(context, callbackHandle);
          result.success(true);
          break;
        case "Alarm.periodic":
          // This message indicates that the Flutter app would like to schedule a periodic
          // task.
          PeriodicRequest periodicRequest = PeriodicRequest.fromJson((JSONArray) arguments);
          AlarmService.setPeriodic(context, periodicRequest);
          result.success(true);
          break;
        case "Alarm.oneShotAt":
          // This message indicates that the Flutter app would like to schedule a one-time
          // task.
          OneShotRequest oneShotRequest = OneShotRequest.fromJson((JSONArray) arguments);
          AlarmService.setOneShot(context, oneShotRequest);
          result.success(true);
          break;
        case "Alarm.cancel":
          // This message indicates that the Flutter app would like to cancel a previously
          // scheduled task.
          int requestCode = ((JSONArray) arguments).getInt(0);
          AlarmService.cancel(context, requestCode);
          result.success(true);
          break;
        default:
          result.notImplemented();
          break;
      }
    } catch (JSONException e) {
      result.error("error", "JSON error: " + e.getMessage(), null);
    } catch (PluginRegistrantException e) {
      result.error("error", "AlarmManager error: " + e.getMessage(), null);
    }
  }

  /** A request to schedule a one-shot Dart task. */
  static final class OneShotRequest {
    static OneShotRequest fromJson(JSONArray json) throws JSONException {
      int requestCode = json.getInt(0);
      boolean alarmClock = json.getBoolean(1);
      boolean allowWhileIdle = json.getBoolean(2);
      boolean exact = json.getBoolean(3);
      boolean wakeup = json.getBoolean(4);
      long startMillis = json.getLong(5);
      boolean rescheduleOnReboot = json.getBoolean(6);
      long callbackHandle = json.getLong(7);
      JSONObject params = json.getJSONObject(8);

      return new OneShotRequest(
          requestCode,
          alarmClock,
          allowWhileIdle,
          exact,
          wakeup,
          startMillis,
          rescheduleOnReboot,
          callbackHandle,
          params);
    }

    final int requestCode;
    final boolean alarmClock;
    final boolean allowWhileIdle;
    final boolean exact;
    final boolean wakeup;
    final long startMillis;
    final boolean rescheduleOnReboot;
    final long callbackHandle;
    final JSONObject params;

    OneShotRequest(
        int requestCode,
        boolean alarmClock,
        boolean allowWhileIdle,
        boolean exact,
        boolean wakeup,
        long startMillis,
        boolean rescheduleOnReboot,
        long callbackHandle,
        JSONObject params) {
      this.requestCode = requestCode;
      this.alarmClock = alarmClock;
      this.allowWhileIdle = allowWhileIdle;
      this.exact = exact;
      this.wakeup = wakeup;
      this.startMillis = startMillis;
      this.rescheduleOnReboot = rescheduleOnReboot;
      this.callbackHandle = callbackHandle;
      this.params = params;
    }
  }

  /** A request to schedule a periodic Dart task. */
  static final class PeriodicRequest {
    static PeriodicRequest fromJson(JSONArray json) throws JSONException {
      int requestCode = json.getInt(0);
      boolean allowWhileIdle = json.getBoolean(1);
      boolean exact = json.getBoolean(2);
      boolean wakeup = json.getBoolean(3);
      long startMillis = json.getLong(4);
      long intervalMillis = json.getLong(5);
      boolean rescheduleOnReboot = json.getBoolean(6);
      long callbackHandle = json.getLong(7);
      JSONObject params = json.getJSONObject(8);
      return new PeriodicRequest(
          requestCode,
          allowWhileIdle,
          exact,
          wakeup,
          startMillis,
          intervalMillis,
          rescheduleOnReboot,
          callbackHandle,
          params);
    }

    final int requestCode;
    final boolean allowWhileIdle;
    final boolean exact;
    final boolean wakeup;
    final long startMillis;
    final long intervalMillis;
    final boolean rescheduleOnReboot;
    final long callbackHandle;
    final JSONObject params;

    PeriodicRequest(
        int requestCode,
        boolean allowWhileIdle,
        boolean exact,
        boolean wakeup,
        long startMillis,
        long intervalMillis,
        boolean rescheduleOnReboot,
        long callbackHandle,
        JSONObject params) {
      this.requestCode = requestCode;
      this.allowWhileIdle = allowWhileIdle;
      this.exact = exact;
      this.wakeup = wakeup;
      this.startMillis = startMillis;
      this.intervalMillis = intervalMillis;
      this.rescheduleOnReboot = rescheduleOnReboot;
      this.callbackHandle = callbackHandle;
      this.params = params;
    }
  }
}
