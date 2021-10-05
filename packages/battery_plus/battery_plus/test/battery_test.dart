// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:async/async.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:test/test.dart';

late StreamController<BatteryState> controller;

class MockBatteryPlatform
    with MockPlatformInterfaceMixin
    implements BatteryPlatform {
  @override
  Future<int> get batteryLevel => Future.value(42);

  @override
  Stream<BatteryState> get onBatteryStateChanged => controller.stream;

  @override
  Future<bool> get isInBatterySaveMode => Future.value(true);

  @override
  Future<String> get batteryHealth => Future.value('BATTERY_HEALTH_GOOD');

  @override
  Future<String> get batteryPluggedType => Future.value('BATTERY_PLUGGED_USB');

  @override
  Future<String> get batteryTechnology => Future.value('Li-ion');

  @override
  Future<double> get batteryTemperature => Future.value(25.0);

  @override
  Future<int> get batteryVoltage => Future.value(5000);

  @override
  Future<int> get batteryCapacity => Future.value(10000);

  @override
  Future<int> get batteryChargeTimeRemaining => Future.value(10000);

  @override
  Future<int> get batteryCurrentAverage => Future.value(500);

  @override
  Future<int> get batteryCurrentNow => Future.value(500);

  @override
  Future<bool> get isBatteryPresent => Future.value(true);

  @override
  Future<int> get batteryRemainingCapacity => Future.value(10000);

  @override
  Future<int> get batteryScale => Future.value(100);
}

void main() {
  late Battery battery;
  late MockBatteryPlatform fakePlatform;

  setUp(() {
    fakePlatform = MockBatteryPlatform();
    BatteryPlatform.instance = fakePlatform;
    battery = Battery();
  });

  test('batteryLevel', () async {
    expect(await battery.batteryLevel, 42);
  });

  test('isInBatterySaveMode', () async {
    expect(await battery.isInBatterySaveMode, true);
  });

  test('batteryHealth', () async {
    expect(await battery.batteryHealth, 'BATTERY_HEALTH_GOOD');
  });

  test('batteryPluggedType', () async {
    expect(await battery.batteryPluggedType, 'BATTERY_PLUGGED_USB');
  });

  test('batteryTechnology', () async {
    expect(await battery.batteryTechnology, 'Li-ion');
  });

  test('batteryTemperature', () async {
    expect(await battery.batteryTemperature, 25.0);
  });

  test('batteryVoltage', () async {
    expect(await battery.batteryVoltage, 5000);
  });

  test('batteryHealth', () async {
    expect(await battery.batteryHealth, 'BATTERY_HEALTH_GOOD');
  });

  test('batteryChargeTimeRemaining', () async {
    expect(await battery.batteryChargeTimeRemaining, 10000);
  });

  test('batteryCurrentAverage', () async {
    expect(await battery.batteryCurrentAverage, 500);
  });

  test('batteryCurrentNow', () async {
    expect(await battery.batteryCurrent, 500);
  });

  test('batteryPresent', () async {
    expect(await battery.isBatteryPresent, true);
  });

  test('batteryRemainingCapacity', () async {
    expect(await battery.batteryRemainingCapacity, 10000);
  });

  test('batteryScale', () async {
    expect(await battery.batteryScale, 100);
  });

  group('battery state', () {
    setUp(() {
      controller = StreamController<BatteryState>();
    });

    tearDown(() {
      controller.close();
    });

    test('receive values', () async {
      final queue = StreamQueue<BatteryState>(battery.onBatteryStateChanged);

      controller.add(BatteryState.full);
      expect(await queue.next, BatteryState.full);

      controller.add(BatteryState.discharging);
      expect(await queue.next, BatteryState.discharging);

      controller.add(BatteryState.charging);
      expect(await queue.next, BatteryState.charging);

      controller.add(BatteryState.unknown);
      expect(await queue.next, BatteryState.unknown);
    });
  });
}
