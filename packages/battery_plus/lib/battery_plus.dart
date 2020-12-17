// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:battery_plus_platform_interface/src/method_channel_battery_plus.dart';
import 'package:battery_plus_linux/battery_plus_linux.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart'
    show BatteryState;

/// API for accessing information about the battery of the device the Flutter
class Battery {
  /// Constructs a singleton instance of [Battery].
  ///
  /// [Battery] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory Battery() {
    _singleton ??= Battery._();
    return _singleton;
  }

  Battery._();

  static Battery _singleton;

  static bool _manualDartRegistrationNeeded = true;

  static BatteryPlatform get _platform {
    // This is to manually endorse Dart implementations until automatic
    // registration of Dart plugins is implemented. For details see
    // https://github.com/flutter/flutter/issues/52267.
    if (_manualDartRegistrationNeeded) {
      // Only do the initial registration if it hasn't already been overridden
      // with a non-default instance.
      if (!kIsWeb && BatteryPlatform.instance is MethodChannelBattery) {
        if (Platform.isLinux) {
          BatteryPlatform.instance = BatteryPlusLinux();
        }
      }
      _manualDartRegistrationNeeded = false;
    }
    return BatteryPlatform.instance;
  }

  /// get battery level
  Future<int> get batteryLevel {
    return _platform.batteryLevel;
  }

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    return _platform.onBatteryStateChanged;
  }
}
