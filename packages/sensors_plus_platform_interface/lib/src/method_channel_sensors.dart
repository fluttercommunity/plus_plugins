// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// A method channel -based implementation of the SensorsPlatform interface.
class MethodChannelSensors extends SensorsPlatform {
  static const EventChannel _accelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/accelerometer');

  static const EventChannel _userAccelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/user_accel');

  static const EventChannel _gyroscopeEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  Stream<AccelerometerEvent> _accelerometerEvents;
  Stream<GyroscopeEvent> _gyroscopeEvents;
  Stream<UserAccelerometerEvent> _userAccelerometerEvents;

  /// A broadcast stream of events from the device accelerometer.
  Stream<AccelerometerEvent> get accelerometerEvents {
    if (_accelerometerEvents == null) {
      _accelerometerEvents = _accelerometerEventChannel
          .receiveBroadcastStream()
          .map((dynamic event) {
        final list = event.cast<double>();
        return AccelerometerEvent(list[0], list[1], list[2]);
      });
    }
    return _accelerometerEvents;
  }

  /// A broadcast stream of events from the device gyroscope.
  Stream<GyroscopeEvent> get gyroscopeEvents {
    if (_gyroscopeEvents == null) {
      _gyroscopeEvents =
          _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
        final list = event.cast<double>();
        return GyroscopeEvent(list[0], list[1], list[2]);
      });
    }
    return _gyroscopeEvents;
  }

  /// Events from the device accelerometer with gravity removed.
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    if (_userAccelerometerEvents == null) {
      _userAccelerometerEvents = _userAccelerometerEventChannel
          .receiveBroadcastStream()
          .map((dynamic event) {
        final list = event.cast<double>();
        return UserAccelerometerEvent(list[0], list[1], list[2]);
      });
    }
    return _userAccelerometerEvents;
  }
}
