// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart'
    show LocationAuthorizationStatus;

export 'src/network_info_plus_linux.dart';
export 'src/network_info_plus_windows.dart'
    if (dart.library.js_interop) 'src/network_info_plus_web.dart';

/// Discovers network information such as Wi-Fi details and IP addresses.
///
/// This class is implemented as a singleton to avoid multiple instances
/// interfering with platform channels.
class NetworkInfo {
  /// Internal singleton instance.
  static final NetworkInfo _instance = NetworkInfo._();

  /// Constructs a singleton instance of [NetworkInfo].
  ///
  /// Creating multiple instances may cause unexpected behavior with
  /// platform channels, therefore this class enforces a singleton pattern.
  factory NetworkInfo() => _instance;

  NetworkInfo._();

  // This manually endorses Dart implementations until automatic
  // registration of Dart plugins is implemented.
  // See: https://github.com/flutter/flutter/issues/52267
  static NetworkInfoPlatform get _platform {
    return NetworkInfoPlatform.instance;
  }

  /// Obtains the Wi-Fi name (SSID) of the currently connected network.
  ///
  /// Returns `null` if:
  /// - The device is not connected to Wi-Fi
  /// - Running on an emulator
  /// - Required permissions are missing
  ///
  /// ⚠️ On Android 8.0+, location services (GPS) must be enabled
  /// with high accuracy to retrieve the SSID.
  Future<String?> getWifiName() {
    return _platform.getWifiName();
  }

  /// Obtains the Wi-Fi BSSID of the currently connected network.
  ///
  /// Returns `null` if:
  /// - The device is not connected to Wi-Fi
  /// - Running on an emulator
  /// - Required permissions are missing
  ///
  /// ⚠️ On Android 8.0+, location services (GPS) must be enabled
  /// with high accuracy to retrieve the BSSID.
  Future<String?> getWifiBSSID() {
    return _platform.getWifiBSSID();
  }

  /// Obtains the IPv4 address of the connected Wi-Fi network.
  ///
  /// Returns `null` if the information is unavailable
  /// or the platform does not support this feature.
  Future<String?> getWifiIP() {
    return _platform.getWifiIP();
  }

  /// Obtains the IPv6 address of the connected Wi-Fi network.
  ///
  /// Returns `null` if the information is unavailable
  /// or the platform does not support this feature.
  Future<String?> getWifiIPv6() {
    return _platform.getWifiIPv6();
  }

  /// Obtains the subnet mask of the connected Wi-Fi network.
  ///
  /// Returns `null` if the information is unavailable
  /// or the platform does not support this feature.
  Future<String?> getWifiSubmask() {
    return _platform.getWifiSubmask();
  }

  /// Obtains the gateway IP address of the connected Wi-Fi network.
  ///
  /// Returns `null` if the information is unavailable
  /// or the platform does not support this feature.
  Future<String?> getWifiGatewayIP() {
    return _platform.getWifiGatewayIP();
  }

  /// Obtains the broadcast address of the connected Wi-Fi network.
  ///
  /// Returns `null` if the information is unavailable
  /// or the platform does not support this feature.
  Future<String?> getWifiBroadcast() {
    return _platform.getWifiBroadcast();
  }
}
