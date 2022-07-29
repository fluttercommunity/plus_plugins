// Copyright 2020, the Chromium authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Can get Battery level', () {
    testWidgets('Android', (WidgetTester tester) async {
      final battery = Battery();
      final batteryLevel = await battery.batteryLevel;
      expect(batteryLevel, isNotNull);
    });
  }, skip: !Platform.isAndroid);

  testWidgets('Can get battery level', (WidgetTester tester) async {
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;
    expect(batteryLevel, isNotNull);
  });

  group('Can get if device is in power mode', () {
    testWidgets('Can get if device is in power mode',
            (WidgetTester tester) async {
          final battery = Battery();
          final isInBatterySaveMode = await battery.isInBatterySaveMode;
          debugPrint('$isInBatterySaveMode');
          expect(isInBatterySaveMode, isNotNull);
        }, skip: !Platform.isAndroid);
  });

  testWidgets('Can get if device is in power mode',
          (WidgetTester tester) async {
        final battery = Battery();
        final isInBatterySaveMode = await battery.isInBatterySaveMode;
        debugPrint('$isInBatterySaveMode');
        expect(isInBatterySaveMode, isNotNull);
      });
}
