package io.flutter.plugins.androidintentexample;

import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;

import androidx.annotation.NonNull;

import org.json.JSONObject;

import java.util.List;

import dev.fluttercommunity.plus.androidintent.Bundle.AndroidOsBundle;
import dev.fluttercommunity.plus.androidintent.Bundle.Bundles;
import dev.fluttercommunity.plus.androidintent.Bundle.Helpers;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "io.flutter.plugins.androidintentexample/integration_tests";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    IntentFilter filter = new IntentFilter("com.example.broadcast");
    MyBroadcastReceiver receiver = new MyBroadcastReceiver();
    registerReceiver(receiver, filter);

    filter = new IntentFilter("io.flutter.plugins.androidintentexample.ACTION");
    filter.addCategory(Intent.CATEGORY_DEFAULT);
    BarcodeBroadcastReceiver barcodeBroadcastReceiver = new BarcodeBroadcastReceiver();
    registerReceiver(barcodeBroadcastReceiver, filter);
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    super.configureFlutterEngine(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
        .setMethodCallHandler(
            (call, result) -> {

              if ("createBundleAndReturn".equalsIgnoreCase(call.method)) {
                try {
                  final String listOfAndroidOsBundleAsJson = Helpers.notNullOrThrow(call.argument("extras"), "No extras provided");
                  final List<Bundle> _androidOsBundles = AndroidOsBundle.fromJsonString(listOfAndroidOsBundleAsJson);
                  final Bundles _bundles = Bundles.fromListOfAndroidOsBundle(_androidOsBundles);
                  final JSONObject jsonObject = _bundles.toJson();
                  result.success(jsonObject.toString());
                } catch (Exception exception) {
                  result.error("onMethodCall", exception.getMessage(), null);
                }
              } else {
                result.notImplemented();
              }
            }
        );
  }
}
