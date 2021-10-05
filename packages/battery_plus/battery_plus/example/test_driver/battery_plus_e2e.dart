// Copyright 2020, the Chromium authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can get if battery is present', (WidgetTester tester) async {
    final battery = Battery();
    final isBatteryPresent = await battery.isBatteryPresent;
    expect(isBatteryPresent, isNotNull);
  });

  testWidgets('Can get battery level', (WidgetTester tester) async {
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;
    expect(batteryLevel, isNotNull);
  });

  testWidgets('Can get if device is in power mode',
      (WidgetTester tester) async {
    final battery = Battery();
    final isInBatterySaveMode = await battery.isInBatterySaveMode;
    expect(isInBatterySaveMode, isNotNull);
  });

  testWidgets('Can get battery health', (WidgetTester tester) async {
    final battery = Battery();
    final batteryHealth = await battery.batteryHealth;
    expect(batteryHealth, isNotNull);
  });

  testWidgets('Can get battery capacity', (WidgetTester tester) async {
    final battery = Battery();
    final batteryCapacity = await battery.batteryCapacity;
    expect(batteryCapacity, isNotNull);
  });

  testWidgets('Can get battery plugged type', (WidgetTester tester) async {
    final battery = Battery();
    final batteryPluggedType = await battery.batteryPluggedType;
    expect(batteryPluggedType, isNotNull);
  });

  testWidgets('Can get battery technology', (WidgetTester tester) async {
    final battery = Battery();
    final batteryTechnology = await battery.batteryTechnology;
    expect(batteryTechnology, isNotNull);
  });

  testWidgets('Can get battery temperature', (WidgetTester tester) async {
    final battery = Battery();
    final batteryTemperature = await battery.batteryTemperature;
    expect(batteryTemperature, isNotNull);
  });

  testWidgets('Can get battery voltage', (WidgetTester tester) async {
    final battery = Battery();
    final batteryVoltage = await battery.batteryVoltage;
    expect(batteryVoltage, isNotNull);
  });

  testWidgets('Can get battery current average', (WidgetTester tester) async {
    final battery = Battery();
    final batteryCurrentAverage = await battery.batteryCurrentAverage;
    expect(batteryCurrentAverage, isNotNull);
  });

  testWidgets('Can get present battery current', (WidgetTester tester) async {
    final battery = Battery();
    final batteryCurrent = await battery.batteryCurrent;
    expect(batteryCurrent, isNotNull);
  });

  testWidgets('Can get battery charge time remaining',
      (WidgetTester tester) async {
    final battery = Battery();
    final batteryChargeTimeRemaining = await battery.batteryChargeTimeRemaining;
    expect(batteryChargeTimeRemaining, isNotNull);
  });

  testWidgets('Can get battery scale', (WidgetTester tester) async {
    final battery = Battery();
    final batteryScale = await battery.batteryScale;
    expect(batteryScale, isNotNull);
  });
}
