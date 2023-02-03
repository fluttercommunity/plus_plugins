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
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.ArrayList;
import java.util.Map;

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
    Bundle arguments = convertArguments((Map<String, ?>) call.argument("arguments"));
    Bundle arrayArguments = convertArrayArguments((Map<String, ?>) call.argument("arrayArguments"));
    arguments.putAll(arrayArguments);
    Bundle nestedArguments = NestedArguments.convertArguments((ArrayList<ArrayList<String>>) call.argument("nestedArgumentsArrayLists"), (Map<String, ?>) call.argument("nestedArguments"));
    arguments.putAll(nestedArguments);
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

  private static Bundle convertArguments(Map<String, ?> arguments) {
    Bundle bundle = new Bundle();
    if (arguments == null) {
      return bundle;
    }
    for (String key : arguments.keySet()) {
      Object value = arguments.get(key);
      if (value instanceof Integer) {
        bundle.putInt(key, (Integer) value);
      } else if (value instanceof String) {
        bundle.putString(key, (String) value);
      } else if (value instanceof Boolean) {
        bundle.putBoolean(key, (Boolean) value);
      } else if (value instanceof Double) {
        bundle.putDouble(key, (Double) value);
      } else if (value instanceof Long) {
        bundle.putLong(key, (Long) value);
      } else if (value instanceof byte[]) {
        bundle.putByteArray(key, (byte[]) value);
      } else if (value instanceof int[]) {
        bundle.putIntArray(key, (int[]) value);
      } else if (value instanceof long[]) {
        bundle.putLongArray(key, (long[]) value);
      } else if (value instanceof double[]) {
        bundle.putDoubleArray(key, (double[]) value);
      } else if (Helpers.isTypedArrayList(value, Integer.class)) {
        bundle.putIntegerArrayList(key, (ArrayList<Integer>) value);
      } else if (Helpers.isTypedArrayList(value, String.class)) {
        bundle.putStringArrayList(key, (ArrayList<String>) value);
      } else if (Helpers.isStringKeyedMap(value)) {
        bundle.putBundle(key, convertArguments((Map<String, ?>) value));
      } else {
        throw new UnsupportedOperationException("Unsupported type " + value);
      }
    }
    return bundle;
  }

  private static Bundle convertArrayArguments(Map<String, ?> arrayArguments) {
    Bundle bundle = new Bundle();
    if (arrayArguments == null) {
      return bundle;
    }
    for (String key : arrayArguments.keySet()) {
      Object value = arrayArguments.get(key);
      if (Helpers.isTypedArrayList(value, Boolean.class)) {
        ArrayList<Boolean> list = (ArrayList<Boolean>) value;
        boolean[] array = new boolean[list.size()];
        for (int i = 0; i < list.size(); i++) {
          array[i] = list.get(i);
        }
        bundle.putBooleanArray(key, array);
      } else if (Helpers.isTypedArrayList(value, Integer.class)) {
        ArrayList<Integer> list = (ArrayList<Integer>) value;
        int[] array = new int[list.size()];
        for (int i = 0; i < list.size(); i++) {
          array[i] = list.get(i);
        }
        bundle.putIntArray(key, array);
      } else if (Helpers.isTypedArrayList(value, Long.class)) {
        ArrayList<Long> list = (ArrayList<Long>) value;
        long[] array = new long[list.size()];
        for (int i = 0; i < list.size(); i++) {
          array[i] = list.get(i);
        }
        bundle.putLongArray(key, array);
      } else if (Helpers.isTypedArrayList(value, Double.class)) {
        ArrayList<Double> list = (ArrayList<Double>) value;
        double[] array = new double[list.size()];
        for (int i = 0; i < list.size(); i++) {
          array[i] = list.get(i);
        }
        bundle.putDoubleArray(key, array);
      } else if (Helpers.isTypedArrayList(value, String.class)) {
        ArrayList<String> list = (ArrayList<String>) value;
        bundle.putStringArray(key, list.toArray(new String[list.size()]));
      } else {
        throw new UnsupportedOperationException("Unsupported type " + value);
      }
    }
    return bundle;
  }
}
