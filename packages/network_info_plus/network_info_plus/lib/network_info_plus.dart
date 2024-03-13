// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart'
    show LocationAuthorizationStatus;

export 'src/network_info_plus_linux.dart';
export 'src/network_info_plus_windows.dart'
    if (dart.library.html) 'src/network_info_plus_web.dart';

/// Discover network info: check WI-FI details and more.
class NetworkInfo {
  /// Constructs a singleton instance of [NetworkInfo].
  ///
  /// [NetworkInfo] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory NetworkInfo() {
    _singleton ??= NetworkInfo._();
    return _singleton!;
  }

  NetworkInfo._();

  static NetworkInfo? _singleton;

  // This is to manually endorse Dart implementations until automatic
  // registration of Dart plugins is implemented. For details see
  // https://github.com/flutter/flutter/issues/52267.
  static NetworkInfoPlatform get _platform {
    return NetworkInfoPlatform.instance;
  }

  /// Obtains the wifi name (SSID) of the connected network
  ///
  /// Please note that it DOESN'T WORK on emulators (returns null).
  ///
  /// From android 8.0 onwards the GPS must be ON (high accuracy)
  /// in order to be able to obtain the SSID.
  Future<String?> getWifiName() {
    return _platform.getWifiName();
  }

  /// Obtains the wifi BSSID of the connected network.
  ///
  /// Please note that it DOESN'T WORK on emulators (returns null).
  ///
  /// From Android 8.0 onwards the GPS must be ON (high accuracy)
  /// in order to be able to obtain the BSSID.
  Future<String?> getWifiBSSID() {
    return _platform.getWifiBSSID();
  }

  /// Obtains the IPv4 address of the connected wifi network
  Future<String?> getWifiIP() {
    return _platform.getWifiIP();
  }

  /// Obtains the IPv6 address of the connected wifi network
  Future<String?> getWifiIPv6() {
    return _platform.getWifiIPv6();
  }

  /// Obtains the submask of the connected wifi network
  Future<String?> getWifiSubmask() {
    return _platform.getWifiSubmask();
  }

  /// Obtains the gateway IP address of the connected wifi network
  Future<String?> getWifiGatewayIP() {
    return _platform.getWifiGatewayIP();
  }

  /// Obtains the broadcast of the connected wifi network
  Future<String?> getWifiBroadcast() {
    return _platform.getWifiBroadcast();
  }
}
