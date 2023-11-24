// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// A method channel -based implementation of the SensorsPlatform interface.
class MethodChannelSensors extends SensorsPlatform {
  static const MethodChannel _methodChannel =
      MethodChannel('dev.fluttercommunity.plus/sensors/method');

  static const EventChannel _accelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/accelerometer');

  static const EventChannel _userAccelerometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/user_accel');

  static const EventChannel _gyroscopeEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/gyroscope');

  static const EventChannel _magnetometerEventChannel =
      EventChannel('dev.fluttercommunity.plus/sensors/magnetometer');

  final logger = Logger('MethodChannelSensors');
  Stream<AccelerometerEvent>? _accelerometerEvents;
  Stream<GyroscopeEvent>? _gyroscopeEvents;
  Stream<UserAccelerometerEvent>? _userAccelerometerEvents;
  Stream<MagnetometerEvent>? _magnetometerEvents;

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setAccelerationSamplingPeriod', microseconds);
    _accelerometerEvents ??= _accelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return AccelerometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _accelerometerEvents!;
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setGyroscopeSamplingPeriod', microseconds);
    _gyroscopeEvents ??=
        _gyroscopeEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return GyroscopeEvent(list[0]!, list[1]!, list[2]!);
    });
    return _gyroscopeEvents!;
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod(
        'setUserAccelerometerSamplingPeriod', microseconds);
    _userAccelerometerEvents ??= _userAccelerometerEventChannel
        .receiveBroadcastStream()
        .map((dynamic event) {
      final list = event.cast<double>();
      return UserAccelerometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _userAccelerometerEvents!;
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    var microseconds = samplingPeriod.inMicroseconds;
    if (microseconds >= 1 && microseconds <= 3) {
      logger.warning('The SamplingPeriod is currently set to $microsecondsμs, '
          'which is a reserved value in Android. Please consider changing it '
          'to either 0 or 4μs. See https://developer.android.com/reference/'
          'android/hardware/SensorManager#registerListener(android.hardware.'
          'SensorEventListener,%20android.hardware.Sensor,%20int) for more '
          'information');
      microseconds = 0;
    }
    _methodChannel.invokeMethod('setMagnetometerSamplingPeriod', microseconds);
    _magnetometerEvents ??=
        _magnetometerEventChannel.receiveBroadcastStream().map((dynamic event) {
      final list = event.cast<double>();
      return MagnetometerEvent(list[0]!, list[1]!, list[2]!);
    });
    return _magnetometerEvents!;
  }
}
