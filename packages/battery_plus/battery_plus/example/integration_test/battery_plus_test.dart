// Copyright 2020, the Chromium authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'dart:io' show Platform, Process;

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path/path.dart' as path;

String getAdbPath(String adbHome) {
  final androidHome = adbHome;
  if (androidHome == null) {
    return 'adb';
  } else {
    return path.join(androidHome, 'platform-tools', 'adb');
  }
}

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
        var result = await Process.run('which', ['adb']);
        // final String androidHome = result.stdout;
        final String androidHome = result.stdout;
        print(androidHome);

    final result2 = await Process.run(
        getAdbPath(androidHome), ['shell', 'dumpsys', 'battery', 'set', 'level', '5']);

    // var result = await Process.start(adbPath(), ['shell', 'dumpsys', 'battery', 'set', 'level', '5']);

    // Map<String, String> envVars = Platform.environment;
    // print(envVars['']);
    // print(envVars['ANDROID_ROOT']);

    print(getAdbPath(androidHome));
    // print(_adbHome);

    // var result = await Process.start('which', ['adb']);
    //
    // print('$result');
    // print(result);
    // var exit Code = await result.exitCode;
  });
}
