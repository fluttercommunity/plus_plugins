// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.network_info;

import android.content.Context;
import android.net.wifi.WifiManager;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;

/** NetworkInfoPlusPlugin */
public class NetworkInfoPlusPlugin implements FlutterPlugin {

  private MethodChannel methodChannel;

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    setupChannels(binding.getBinaryMessenger(), binding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    teardownChannels();
  }

  private void setupChannels(BinaryMessenger messenger, Context context) {
    methodChannel = new MethodChannel(messenger, "dev.fluttercommunity.plus/network_info");
    WifiManager wifiManager =
        (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);

    NetworkInfo networkInfo = new NetworkInfo(wifiManager);

    NetworkInfoMethodChannelHandler methodChannelHandler =
        new NetworkInfoMethodChannelHandler(networkInfo);

    methodChannel.setMethodCallHandler(methodChannelHandler);
  }

  private void teardownChannels() {
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
  }
}
