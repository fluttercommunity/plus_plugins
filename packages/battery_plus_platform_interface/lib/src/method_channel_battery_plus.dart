// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../battery_plus_platform_interface.dart';
import 'enums.dart';
import 'utils.dart';

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

  Stream<BatteryState> _onBatteryStateChanged;

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel => methodChannel
      .invokeMethod<int>('getBatteryLevel')
      .then<int>((dynamic result) => result);

  /// Fires whenever the battery state changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged {
    _onBatteryStateChanged ??= eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => parseBatteryState(event));
    return _onBatteryStateChanged;
  }
}
