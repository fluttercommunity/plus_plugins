// Copyright 2020, the Chromium authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final bool batteryLevelIsImplemented = Platform.isAndroid || Platform.isIOS;
  final bool isInBatterySaveModeIsImplemented =
      Platform.isAndroid || Platform.isIOS || Platform.isWindows;

  /// Throws [PlatformException] on iOS simulator.
  /// Run on Android only.
  testWidgets('Can get battery level', (WidgetTester tester) async {
    final batteryLevel = await Battery().batteryLevel;
    expect(batteryLevel, isNotNull);
  }, skip: !batteryLevelIsImplemented);

  testWidgets('Can get if device is in battery save mode',
      (WidgetTester tester) async {
    final isInBatterySaveMode = await Battery().isInBatterySaveMode;
    expect(isInBatterySaveMode, false);
  }, skip: !isInBatterySaveModeIsImplemented);
}
