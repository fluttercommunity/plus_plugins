// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:battery_plus_platform_interface/method_channel_battery_plus.dart';
import 'package:battery_plus_linux/battery_plus_linux.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart'
    show BatteryState;

/// API for accessing information about the battery of the device the Flutter app is running on.
/// Information derived from `android.os.BatteryManager`.
///
/// See: https://developer.android.com/reference/android/os/BatteryManager
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

  /// Returns <bool> indicating whether a battery is present.
  Future<bool> get isBatteryPresent => _platform.isBatteryPresent;

  /// Returns <int> indicating the current battery level, from 0 to battery scale.
  Future<int> get batteryLevel => _platform.batteryLevel;

  /// Returns <bool> to check if device is on battery save mode.
  Future<bool> get isInBatterySaveMode => _platform.isInBatterySaveMode;

  /// Returns <String> describing the health of the battery.
  ///
  /// The different states of battery health:
  /// * BATTERY_HEALTH_GOOD
  /// * BATTERY_HEALTH_COLD
  /// * BATTERY_HEALTH_DEAD
  /// * BATTERY_HEALTH_OVERHEAT
  /// * BATTERY_HEALTH_OVER_VOLTAGE
  /// * BATTERY_HEALTH_UNSPECIFIED_FAILURE
  /// * BATTERY_HEALTH_UNKNOWN
  ///
  Future<String> get batteryHealth => _platform.batteryHealth;

  /// Returns <int> indicating battery capacity in microampere-hours.
  Future<int> get batteryCapacity => _platform.batteryCapacity;

  /// Returns <String> describing the power source when the device is plugged.
  ///
  /// The different power sources:
  /// * BATTERY_PLUGGED_AC
  /// * BATTERY_PLUGGED_USB
  /// * BATTERY_PLUGGED_WIRELESS
  Future<String> get batteryPluggedType => _platform.batteryPluggedType;

  /// Returns <String> describing the technology of the current battery.
  Future<String> get batteryTechnology => _platform.batteryTechnology;

  /// Returns <int> containing the current battery temperature.
  Future<double> get batteryTemperature => _platform.batteryTemperature;

  /// Returns <int> containing the current battery voltage level.
  Future<int> get batteryVoltage => _platform.batteryVoltage;

  /// Returns <int> indicating the average battery current in microamperes.
  /// Positive values indicate net current entering the battery from a charge source, negative values indicate net current discharging from the battery.
  /// The time period over which the average is computed may depend on the fuel gauge hardware and its configuration.
  Future<int> get batteryCurrentAverage => _platform.batteryCurrentAverage;

  /// Returns <int> indicating the instantaneous battery current in microamperes.
  /// Positive values indicate net current entering the battery from a charge source, negative values indicate net current discharging from the battery.
  Future<int> get batteryCurrent => _platform.batteryCurrentNow;

  ///  Returns <int> indicating the remaining energy in nanowatt-hours.
  Future<int> get batteryRemainingCapacity =>
      _platform.batteryRemainingCapacity;

  /// Returns <int> Computing an approximation for how much time (in milliseconds) remains until the battery is fully charged.
  Future<int> get batteryChargeTimeRemaining =>
      _platform.batteryChargeTimeRemaining;

  /// Returns <int> containing the maximum battery level.
  Future<int> get batteryScale => _platform.batteryScale;

  /// Fires whenever the battery state changes.
  ///
  /// The different battery states:
  /// * batteryState.charging
  /// * batteryState.discharging
  /// * batteryState.notcharging
  /// * batteryState.full
  /// * batteryState.unknown
  Stream<BatteryState> get onBatteryStateChanged =>
      _platform.onBatteryStateChanged;
}
