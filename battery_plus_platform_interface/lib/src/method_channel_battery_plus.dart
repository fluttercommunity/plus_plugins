// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../battery_plus_platform_interface.dart';
import 'enums.dart';
import 'utils.dart';

/// An implementation of [BatteryPlusPlatform] that uses method channels.
class MethodChannelBatteryPlus extends BatteryPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel = MethodChannel('plugins.flutter.io/battery');

  /// The event channel used to receive BatteryState changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel = EventChannel('plugins.flutter.io/charging');

  Stream<BatteryState> _onBatteryStateChanged;

  /// Returns the current battery level in percent.
  Future<int> get batteryLevel => methodChannel
      .invokeMethod<int>('getBatteryLevel')
      .then<int>((dynamic result) => result);

  /// Fires whenever the battery state changes.
  Stream<BatteryState> get onBatteryStateChanged {
    if (_onBatteryStateChanged == null) {
      _onBatteryStateChanged = eventChannel
          .receiveBroadcastStream()
          .map((dynamic event) => parseBatteryState(event));
    }
    return _onBatteryStateChanged;
  }
}
