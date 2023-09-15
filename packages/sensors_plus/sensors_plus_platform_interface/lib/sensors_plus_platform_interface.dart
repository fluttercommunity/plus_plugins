// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';
import 'package:sensors_plus_platform_interface/src/sensor_interval.dart';

import 'src/accelerometer_event.dart';
import 'src/gyroscope_event.dart';
import 'src/magnetometer_event.dart';
import 'src/user_accelerometer_event.dart';

export 'src/accelerometer_event.dart';
export 'src/gyroscope_event.dart';
export 'src/magnetometer_event.dart';
export 'src/user_accelerometer_event.dart';
export 'src/sensor_interval.dart';

/// The common platform interface for sensors.
abstract class SensorsPlatform extends PlatformInterface {
  /// Constructs a SensorsPlatform.
  SensorsPlatform() : super(token: _token);

  static final Object _token = Object();

  static SensorsPlatform _instance = MethodChannelSensors();

  /// The default instance of [SensorsPlatform] to use.
  ///
  /// Defaults to [MethodChannelSensors].
  static SensorsPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SensorsPlatform] when they register themselves.
  static set instance(SensorsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// A broadcast stream of events from the device accelerometer.
  @nonVirtual
  @Deprecated('Use accelerometerEventStream() instead.')
  Stream<AccelerometerEvent> get accelerometerEvents {
    return accelerometerEventStream();
  }

  /// A broadcast stream of events from the device gyroscope.
  @nonVirtual
  @Deprecated('Use gyroscopeEventStream() instead.')
  Stream<GyroscopeEvent> get gyroscopeEvents {
    return gyroscopeEventStream();
  }

  /// Events from the device accelerometer with gravity removed.
  @nonVirtual
  @Deprecated('Use userAccelerometerEventStream() instead.')
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    return userAccelerometerEventStream();
  }

  /// A broadcast stream of events from the device magnetometer.
  @nonVirtual
  @Deprecated('Use magnetometerEventStream() instead.')
  Stream<MagnetometerEvent> get magnetometerEvents {
    return magnetometerEventStream();
  }

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError(
        'listenToAccelerometerEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('gyroscopeEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError(
        'userAccelerometerEvents has not been implemented.');
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    throw UnimplementedError('magnetometerEvents has not been implemented.');
  }
}
