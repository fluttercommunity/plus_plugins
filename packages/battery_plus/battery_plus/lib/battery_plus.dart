// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart'
    show BatteryState;

/// API for accessing information about the battery of the device the Flutter app is running on.
class Battery {
  /// Constructs a singleton instance of [Battery].
  ///
  /// [Battery] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory Battery() {
    _singleton ??= Battery._();
    return _singleton!;
  }

  Battery._();

  static Battery? _singleton;

  static BatteryPlatform get _platform {
    return BatteryPlatform.instance;
  }

  /// get battery level
  Future<int> get batteryLevel {
    return _platform.batteryLevel;
  }

  /// check if device is on battery save mode
  Future<bool> get isInBatterySaveMode {
    return _platform.isInBatterySaveMode;
  }

  /// Get battery state
  Future<BatteryState> get batteryState {
    return _platform.batteryState;
  }

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    return _platform.onBatteryStateChanged;
  }
}
