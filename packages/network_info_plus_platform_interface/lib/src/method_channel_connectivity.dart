// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'utils.dart';

/// An implementation of [ConnectivityPlatform] that uses method channels.
class MethodChannelConnectivity extends ConnectivityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity');

  /// The event channel used to receive ConnectivityResult changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel =
      EventChannel('dev.fluttercommunity.plus/connectivity_status');

  Stream<ConnectivityResult> _onConnectivityChanged;

  /// Fires whenever the connectivity state changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    _onConnectivityChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic result) => result.toString())
        .map(parseConnectivityResult);
    return _onConnectivityChanged;
  }

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return methodChannel
        .invokeMethod<String>('check')
        .then(parseConnectivityResult);
  }

  @override
  Future<String> getWifiName() async {
    var wifiName = await methodChannel.invokeMethod<String>('wifiName');
    // as Android might return <unknown ssid>, uniforming result
    // our iOS implementation will return null
    if (wifiName == '<unknown ssid>') {
      wifiName = null;
    }
    return wifiName;
  }

  @override
  Future<String> getWifiBSSID() {
    return methodChannel.invokeMethod<String>('wifiBSSID');
  }

  @override
  Future<String> getWifiIP() {
    return methodChannel.invokeMethod<String>('wifiIPAddress');
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
