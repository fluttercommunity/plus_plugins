// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:e2e/e2e.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

// From https://flutter.dev/docs/cookbook/persistence/reading-writing-files
Future<String> get _localPath async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

// @miquelbeltran: writeCounter is never called !!!
Future<File> writeCounter(int counter) async {
  debugPrint('writeCounter: $counter');
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  debugPrint('readCounter');
  try {
    final file = await _localFile;

    // Read the file.
    final contents = await file.readAsString();

    debugPrint('read: $contents');
    return int.parse(contents);
    // ignore: unused_catch_clause
  } on FileSystemException catch (e) {
    // If encountering an error, return 0.
    debugPrint('error: $e');
    return 0;
  }
}

Future<void> incrementCounter() async {
  debugPrint('incrementCounter');
  final value = await readCounter();
  await writeCounter(value + 1);
}

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await AndroidAlarmManager.initialize();
  });

  group('oneshot', () {
    testWidgets('cancelled before it fires', (WidgetTester tester) async {
      final alarmId = 0;
      final startingValue = await readCounter();
      debugPrint('oneShot start');
      await AndroidAlarmManager.oneShot(
          const Duration(seconds: 1), alarmId, incrementCounter);
      debugPrint('oneShot end');
      debugPrint('Canceling alarm...');
      expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
      debugPrint('Alarm canceled');
      await Future<void>.delayed(const Duration(seconds: 4));
      expect(await readCounter(), startingValue);
      debugPrint('Test end');
    });

    testWidgets('cancelled after it fires', (WidgetTester tester) async {
      final alarmId = 1;
      final startingValue = await readCounter();
      debugPrint('oneShot start');
      await AndroidAlarmManager.oneShot(
          const Duration(seconds: 1), alarmId, incrementCounter,
          exact: true, wakeup: true);
      debugPrint('oneShot end');
      await Future<void>.delayed(const Duration(seconds: 2));
      // poll until file is updated
      debugPrint('poll until file is updated');
      while (await readCounter() == startingValue) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
      expect(await readCounter(), startingValue + 1);
      debugPrint('Canceling alarm...');
      expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
      debugPrint('Alarm canceled');
      debugPrint('Test end');
    });
  });

  testWidgets('periodic', (WidgetTester tester) async {
    final alarmId = 2;
    final startingValue = await readCounter();
    await AndroidAlarmManager.periodic(
        const Duration(seconds: 1), alarmId, incrementCounter,
        wakeup: true, exact: true);
    // poll until file is updated
    while (await readCounter() < startingValue + 2) {
      await Future<void>.delayed(const Duration(seconds: 1));
    }
    expect(await readCounter(), startingValue + 2);
    expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
    await Future<void>.delayed(const Duration(seconds: 3));
    expect(await readCounter(), startingValue + 2);
  });
}
