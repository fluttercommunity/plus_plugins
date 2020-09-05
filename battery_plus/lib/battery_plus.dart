// Copyright 2020 The Flutter Community Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart'
    show BatteryState;

/// API for accessing information about the battery of the device the Flutter
class BatteryPlus {
  /// Constructs a singleton instance of [BatteryPlus].
  ///
  /// [BatteryPlus] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory BatteryPlus() {
    if (_singleton == null) {
      _singleton = BatteryPlus._();
    }
    return _singleton;
  }

  BatteryPlus._();

  static BatteryPlus _singleton;

  static BatteryPlusPlatform get _platform => BatteryPlusPlatform.instance;

  /// get battery level
  Future<int> get batteryLevel {
    return _platform.batteryLevel;
  }

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    return _platform.onBatteryStateChanged;
  }
}
