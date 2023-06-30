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

  static const EventChannel _magnetometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  static const EventChannel _attitudeEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/attitude');

  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;
  Stream<AttitudeEvent>? _attitudeEvents;

  /// A broadcast stream of events from the device accelerometer.
  @override
  Stream<AccelerometerEvent> get accelerometerEvents {
    _accelerometerEvents ??= _accelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return AccelerometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _accelerometerEvents!;
  }

  /// A broadcast stream of events from the device gyroscope.
  @override
  Stream<GyroscopeEvent> get gyroscopeEvents {
    _gyroscopeEvents ??=
        _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return GyroscopeEvent(list[0]!, list[1]!, list[2]!);
    });
    return _gyroscopeEvents!;
  }

  /// Events from the device accelerometer with gravity removed.
  @override
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    _userAccelerometerEvents ??= _userAccelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return UserAccelerometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _userAccelerometerEvents!;
  }

  /// A broadcast stream of events from the device magnetometer.
  @override
  Stream<MagnetometerEvent> get magnetometerEvents {
    _magnetometerEvents ??=
        _magnetometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return MagnetometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _magnetometerEvents!;
  }

  @override
  Stream<AttitudeEvent> get attitudeEvents {
    _attitudeEvents ??=
        _attitudeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return AttitudeEvent(list[0]!, list[1]!, list[2]!);
    });
    return _attitudeEvents!;
  }
}
