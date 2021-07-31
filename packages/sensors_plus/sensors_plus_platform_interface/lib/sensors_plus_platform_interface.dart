// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sensors_plus_platform_interface/src/method_channel_sensors.dart';

import 'src/accelerometer_event.dart';
import 'src/gyroscope_event.dart';
import 'src/user_accelerometer_event.dart';
import 'src/magnetometer_event.dart';

export 'src/accelerometer_event.dart';
export 'src/gyroscope_event.dart';
export 'src/user_accelerometer_event.dart';
export 'src/magnetometer_event.dart';

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
  Stream<AccelerometerEvent> get accelerometerEvents {
    throw UnimplementedError('accelerometerEvents has not been implemented.');
  }

  /// A broadcast stream of events from the device gyroscope.
  Stream<GyroscopeEvent> get gyroscopeEvents {
    throw UnimplementedError('gyroscopeEvents has not been implemented.');
  }

  /// Events from the device accelerometer with gravity removed.
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    throw UnimplementedError(
        'userAccelerometerEvents has not been implemented.');
  }

  /// A broadcast stream of events from the device magnetometer.
  Stream<MagnetometerEvent> get magnetometerEvents {
    throw UnimplementedError('magnetometerEvents has not been implemented.');
  }
}
