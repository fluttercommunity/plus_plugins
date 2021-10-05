// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'battery_plus_platform_interface.dart';
import 'src/enums.dart';
import 'src/utils.dart';

/// An implementation of [BatteryPlatform] that uses method channels.
class MethodChannelBattery extends BatteryPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      MethodChannel('dev.fluttercommunity.plus/battery');

  /// The event channel used to receive BatteryState changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel =
      EventChannel('dev.fluttercommunity.plus/charging');

  Stream<BatteryState>? _onBatteryStateChanged;

  /// Returns if the battery present
  @override
  Future<bool> get isBatteryPresent => methodChannel
      .invokeMethod<bool>('isBatteryPresent')
      .then<bool>((dynamic result) => result);

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel => methodChannel
      .invokeMethod<int>('getBatteryLevel')
      .then<int>((dynamic result) => result);

  /// Returns true if the device is on battery save mode
  @override
  Future<bool> get isInBatterySaveMode => methodChannel
      .invokeMethod<bool>('isInBatterySaveMode')
      .then<bool>((dynamic result) => result);

  /// Returns the current Battery Health state.
  @override
  Future<String> get batteryHealth => methodChannel
      .invokeMethod<String>('getBatteryHealth')
      .then<String>((dynamic result) => result);

  /// Returns the Battery capacity.
  @override
  Future<int> get batteryCapacity => methodChannel
      .invokeMethod<int>('getBatteryCapacity')
      .then<int>((dynamic result) => result);

  /// Returns the current Battery Health state.
  @override
  Future<String> get batteryPluggedType => methodChannel
      .invokeMethod<String>('getBatteryPluggedType')
      .then<String>((dynamic result) => result);

  /// Returns the battery technology.
  @override
  Future<String> get batteryTechnology => methodChannel
      .invokeMethod<String>('getBatteryTechnology')
      .then<String>((dynamic result) => result);

  /// Returns the battery temperature.
  @override
  Future<double> get batteryTemperature => methodChannel
      .invokeMethod<double>('getBatteryTemperature')
      .then<double>((dynamic result) => result);

  /// Returns the battery voltage.
  @override
  Future<int> get batteryVoltage => methodChannel
      .invokeMethod<int>('getBatteryVoltage')
      .then<int>((dynamic result) => result);

  /// Returns the battery current average.
  @override
  Future<int> get batteryCurrentAverage => methodChannel
      .invokeMethod<int>('getBatteryCurrentAverage')
      .then<int>((dynamic result) => result);

  /// Returns the battery current.
  @override
  Future<int> get batteryCurrentNow => methodChannel
      .invokeMethod<int>('getBatteryCurrentNow')
      .then<int>((dynamic result) => result);

  /// Returns the remaining battery capacity.
  @override
  Future<int> get batteryRemainingCapacity => methodChannel
      .invokeMethod<int>('getBatteryRemainingCapacity')
      .then<int>((dynamic result) => result);

  /// Returns the time remaining for full charge
  @override
  Future<int> get batteryChargeTimeRemaining => methodChannel
      .invokeMethod<int>('getBatteryChargeTimeRemaining')
      .then<int>((dynamic result) => result);

  /// Returns the total battery capacity
  @override
  Future<int> get batteryScale => methodChannel
      .invokeMethod<int>('getBatteryScale')
      .then<int>((dynamic result) => result);

  /// Fires whenever the battery state changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged {
    _onBatteryStateChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic event) => parseBatteryState(event));
    return _onBatteryStateChanged!;
  }
}
