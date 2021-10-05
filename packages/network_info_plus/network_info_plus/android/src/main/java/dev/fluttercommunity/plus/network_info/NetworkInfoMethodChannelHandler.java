// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.fluttercommunity.plus.network_info;

import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * The handler receives {@link MethodCall}s from the UIThread, gets the related information from
 * a @{@link NetworkInfo}, and then send the result back to the UIThread through the {@link
 * MethodChannel.Result}.
 */
class NetworkInfoMethodChannelHandler implements MethodChannel.MethodCallHandler {

  private final NetworkInfo networkInfo;

  /**
   * Construct the NetworkInfoMethodChannelHandler with a {@code networkInfo}. The {@code
   * networkInfo} must not be null.
   */
  NetworkInfoMethodChannelHandler(NetworkInfo networkInfo) {
    assert (networkInfo != null);
    this.networkInfo = networkInfo;
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull MethodChannel.Result result) {
    switch (call.method) {
      case "wifiName":
        result.success(networkInfo.getWifiName());
        break;
      case "wifiBSSID":
        result.success(networkInfo.getWifiBSSID());
        break;
      case "wifiIPAddress":
        result.success(networkInfo.getWifiIPAddress());
        break;
      case "wifiBroadcast":
        result.success(networkInfo.getBroadcast());
        break;
      case "wifiSubmask":
        result.success(networkInfo.getWifiSubnetMask());
        break;
      case "wifiGatewayAddress":
        result.success(networkInfo.getGatewayIpAdress());
        break;
      case "wifiIPv6Address":
        result.success(networkInfo.getIpV6());
        break;
      default:
        result.notImplemented();
        break;
    }
  }
}
