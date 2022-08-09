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

  testWidgets('Can get battery level', (WidgetTester tester) async {
    final battery = Battery();
    final batteryLevel = await battery.batteryLevel;
    expect(batteryLevel, isNotNull);
  });

  testWidgets('Can get if device is in power mode',
      (WidgetTester tester) async {
    final battery = Battery();
    final isInBatterySaveMode = await battery.isInBatterySaveMode;
    debugPrint('$isInBatterySaveMode');
    expect(isInBatterySaveMode, isFalse);
  });

  testWidgets('test if device is in low power mode',
      (WidgetTester tester) async {
    final battery = Battery();

    await Process.run(
        'adb', ['shell', 'dumpsys', 'battery', 'set', 'level', '5'],
    runInShell: true);

    expect(await battery.batteryLevel, 5);

  });
}
