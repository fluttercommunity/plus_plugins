package dev.fluttercommunity.plus.androidintent;

import android.content.ComponentName;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.provider.Settings;
import android.text.TextUtils;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONException;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.Bundles;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** Forwards incoming {@link MethodCall}s to {@link IntentSender#send}. */
public final class MethodCallHandlerImpl implements MethodCallHandler {
  private static final String TAG = "MethodCallHandlerImpl";
  private final IntentSender sender;
  @Nullable private MethodChannel methodChannel;

  /**
   * Uses the given {@code sender} for all incoming calls.
   *
   * <p>This assumes that the sender's context and activity state are managed elsewhere and
   * correctly initialized before being sent here.
   */
  MethodCallHandlerImpl(IntentSender sender) {
    this.sender = sender;
  }

  /**
   * Registers this instance as a method call handler on the given {@code messenger}.
   *
   * <p>Stops any previously started and unstopped calls.
   *
   * <p>This should be cleaned with {@link #stopListening} once the messenger is disposed of.
   */
  void startListening(BinaryMessenger messenger) {
    if (methodChannel != null) {
      Log.wtf(TAG, "Setting a method call handler before the last was disposed.");
      stopListening();
    }

    methodChannel = new MethodChannel(messenger, "dev.fluttercommunity.plus/android_intent");
    methodChannel.setMethodCallHandler(this);
  }

  /**
   * Clears this instance from listening to method calls.
   *
   * <p>Does nothing is {@link #startListening} hasn't been called, or if we're already stopped.
   */
  void stopListening() {
    if (methodChannel == null) {
      Log.d(TAG, "Tried to stop listening when no methodChannel had been initialized.");
      return;
    }

    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }

  /**
   * Parses the incoming call and forwards it to the cached {@link IntentSender}.
   *
   * <p>Always calls {@code result#success}.
   */
  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    String action = convertAction((String) call.argument("action"));
    Integer flags = call.argument("flags");
    String category = call.argument("category");
    Uri data = call.argument("data") != null ? Uri.parse((String) call.argument("data")) : null;
    Bundle arguments = new Bundle();
    Bundles bundles;
    try {
      bundles = Bundles.bundlesFromJsonString((String) call.argument("extras"));
    } catch (JSONException e) {
      throw new RuntimeException(e);
    }
    List<Bundle> androidOsBundles = bundles.toListOfAndroidOsBundle();
    for (Bundle bundle : androidOsBundles) {
      arguments.putAll(bundle);
    }
    String packageName = call.argument("package");
    ComponentName componentName =
        (!TextUtils.isEmpty(packageName)
                && !TextUtils.isEmpty((String) call.argument("componentName")))
            ? new ComponentName(packageName, (String) call.argument("componentName"))
            : null;
    String type = call.argument("type");

    Intent intent =
        sender.buildIntent(
            action, flags, category, data, arguments, packageName, componentName, type);

    if ("launch".equalsIgnoreCase(call.method)) {

      if (intent != null && !sender.canResolveActivity(intent)) {
        Log.i(TAG, "Cannot resolve explicit intent, falling back to implicit");
        intent.setPackage(null);
      }

      sender.send(intent);
      result.success(null);
    } else if ("launchChooser".equalsIgnoreCase(call.method)) {
      String title = call.argument("chooserTitle");

      sender.launchChooser(intent, title);
      result.success(null);
    } else if ("sendBroadcast".equalsIgnoreCase(call.method)) {
      sender.sendBroadcast(intent);
      result.success(null);
    } else if ("canResolveActivity".equalsIgnoreCase(call.method)) {
      result.success(sender.canResolveActivity(intent));
    } else {
      result.notImplemented();
    }
  }

  private static String convertAction(String action) {
    if (action == null) {
      return null;
    }

    switch (action) {
      case "action_view":
        return Intent.ACTION_VIEW;
      case "action_voice":
        return Intent.ACTION_VOICE_COMMAND;
      case "settings":
        return Settings.ACTION_SETTINGS;
      case "action_location_source_settings":
        return Settings.ACTION_LOCATION_SOURCE_SETTINGS;
      case "action_application_details_settings":
        return Settings.ACTION_APPLICATION_DETAILS_SETTINGS;
      default:
        return action;
    }
  }
}
