// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:sensors_plus/sensors_plus.dart';
import 'package:test/test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('accelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/accelerometer';
    final date = DateTime.now();
    final sensorData = <double>[
      1.0,
      2.0,
      3.0,
      date.microsecondsSinceEpoch.toDouble(),
    ];
    _initializeFakeMethodChannel('setAccelerationSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await accelerometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.timestamp, date);
  });

  test('gyroscopeEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/gyroscope';
    final date = DateTime.now();
    final sensorData = <double>[
      3.0,
      4.0,
      5.0,
      date.microsecondsSinceEpoch.toDouble(),
    ];
    _initializeFakeMethodChannel('setGyroscopeSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await gyroscopeEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.timestamp, date);
  });

  test('userAccelerometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/user_accel';
    final date = DateTime.now();
    final sensorData = <double>[
      6.0,
      7.0,
      8.0,
      date.microsecondsSinceEpoch.toDouble(),
    ];
    _initializeFakeMethodChannel('setUserAccelerometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await userAccelerometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.timestamp, date);
  });

  test('magnetometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/magnetometer';
    final date = DateTime.now();
    final sensorData = <double>[
      8.0,
      9.0,
      10.0,
      date.microsecondsSinceEpoch.toDouble(),
    ];
    _initializeFakeMethodChannel('setMagnetometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await magnetometerEventStream().first;

    expect(event.x, sensorData[0]);
    expect(event.y, sensorData[1]);
    expect(event.z, sensorData[2]);
    expect(event.timestamp, date);
  });

  test('barometerEvents are streamed', () async {
    const channelName = 'dev.fluttercommunity.plus/sensors/barometer';
    final date = DateTime.now();
    final sensorData = <double>[1000.0, date.microsecondsSinceEpoch.toDouble()];
    _initializeFakeMethodChannel('setBarometerSamplingPeriod');
    _initializeFakeSensorChannel(channelName, sensorData);

    final event = await barometerEventStream().first;

    expect(event.pressure, sensorData[0]);
    expect(event.timestamp, date);
  });
}

void _initializeFakeMethodChannel(String methodName) {
  const standardMethod = StandardMethodCodec();

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('dev.fluttercommunity.plus/sensors/method', (
        ByteData? message,
      ) async {
        final methodCall = standardMethod.decodeMethodCall(message);
        if (methodCall.method == methodName) {
          return standardMethod.encodeSuccessEnvelope(null);
        } else {
          fail('Expected $methodName');
        }
      });
}

void _initializeFakeSensorChannel(String channelName, List<double> sensorData) {
  const standardMethod = StandardMethodCodec();

  void emitEvent(ByteData? event) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .handlePlatformMessage(channelName, event, (ByteData? reply) {});
  }

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler(channelName, (ByteData? message) async {
        final methodCall = standardMethod.decodeMethodCall(message);
        if (methodCall.method == 'listen') {
          emitEvent(standardMethod.encodeSuccessEnvelope(sensorData));
          emitEvent(null);
          return standardMethod.encodeSuccessEnvelope(null);
        } else if (methodCall.method == 'cancel') {
          return standardMethod.encodeSuccessEnvelope(null);
        } else {
          fail('Expected listen or cancel');
        }
      });
}
