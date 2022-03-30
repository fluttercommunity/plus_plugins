// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'src/utils.dart';

/// An implementation of [NetworkInfoPlatform] that uses method channels.
class MethodChannelNetworkInfo extends NetworkInfoPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      const MethodChannel('dev.fluttercommunity.plus/network_info');

  @override
  Future<String?> getWifiName() async {
    var wifiName = await methodChannel.invokeMethod<String>('wifiName');
    // as Android might return <unknown ssid>, uniforming result
    // our iOS implementation will return null
    if (wifiName == '<unknown ssid>') {
      wifiName = null;
    }
    return wifiName;
  }

  @override
  Future<String?> getWifiBSSID() {
    return methodChannel.invokeMethod<String>('wifiBSSID');
  }

  @override
  Future<String?> getWifiIP() {
    return methodChannel.invokeMethod<String>('wifiIPAddress');
  }

  @override
  Future<String?> getWifiIPv6() {
    return methodChannel.invokeMethod<String>('wifiIPv6Address');
  }

  @override
  Future<String?> getWifiSubmask() {
    return methodChannel.invokeMethod<String>('wifiSubmask');
  }

  @override
  Future<String?> getWifiGatewayIP() {
    return methodChannel.invokeMethod<String>('wifiGatewayAddress');
  }

  @override
  Future<String?> getWifiBroadcast() {
    return methodChannel.invokeMethod<String>('wifiBroadcast');
  }

  @override
  Future<LocationAuthorizationStatus> requestLocationServiceAuthorization({
    bool requestAlwaysLocationUsage = false,
  }) {
    return methodChannel.invokeMethod<String>(
        'requestLocationServiceAuthorization', <bool>[
      requestAlwaysLocationUsage
    ]).then(parseLocationAuthorizationStatus);
  }

  @override
  Future<LocationAuthorizationStatus> getLocationServiceAuthorization() {
    return methodChannel
        .invokeMethod<String>('getLocationServiceAuthorization')
        .then(parseLocationAuthorizationStatus);
  }
}
