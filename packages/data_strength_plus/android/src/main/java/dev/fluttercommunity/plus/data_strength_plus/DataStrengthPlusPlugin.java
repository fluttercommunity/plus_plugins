package dev.fluttercommunity.plus.data_strength_plus;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** DataStrengthPlusPlugin */
public class DataStrengthPlusPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context context;
  private DataStrengthHelper dataStrengthHelper;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "data_strength_plus");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
    dataStrengthHelper = new DataStrengthHelper(context);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    }

    if (call.method.equals("getMobileSignalStrength")) {
      Integer mobileSignal = dataStrengthHelper.getMobileSignalStrength();
      result.success(mobileSignal);
    }

    if (call.method.equals("getWifiSignalStrength")) {
      Integer wifiSignal = dataStrengthHelper.getWifiSignalStrength();
      result.success(wifiSignal);
    }

    if (call.method.equals("getWifiLinkSpeed")) {
      Integer wifiLinkSpeed = dataStrengthHelper.getWifiLinkSpeed();
      result.success(wifiLinkSpeed);
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
