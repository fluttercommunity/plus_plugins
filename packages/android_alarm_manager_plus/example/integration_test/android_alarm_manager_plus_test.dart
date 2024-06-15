// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate';
import 'dart:ui';

import 'package:android_alarm_manager_plus_example/main.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

class AlarmHelpers {
  static void alarmTest() {
    return;
  }
}

Future<void> main() async {
  String invalidCallback(String foo) => foo;
  void validCallback(int id) {
    return;
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Example app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AlarmManagerExampleApp());

    // Verify that the example app builds
    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text && widget.data!.startsWith('Schedule OneShot Alarm'),
      ),
      findsOneWidget,
    );
  });

  group('AndroidAlarmManager', () {
    test('can be initialized', () async {
      final initialized = await AndroidAlarmManager.initialize();
      expect(initialized, isTrue);
    });

    group('oneShotAt', () {
      test('validates input', () async {
        final validTime = DateTime.utc(1993);
        const validId = 1;

        // Callback should take a single int param.
        await expectLater(
          () => AndroidAlarmManager.oneShotAt(
            validTime,
            validId,
            invalidCallback,
          ),
          throwsAssertionError,
        );

        // ID should be less than 32 bits.
        await expectLater(
          () => AndroidAlarmManager.oneShotAt(
            validTime,
            2147483648,
            validCallback,
          ),
          throwsAssertionError,
        );
      });

      test('sends arguments to the device', () async {
        final alarm = DateTime.now();
        const id = 1;
        const alarmClock = true;
        const allowWhileIdle = true;
        const exact = true;
        const wakeup = true;
        const rescheduleOnReboot = true;

        final result = await AndroidAlarmManager.oneShotAt(
          alarm,
          id,
          AlarmHelpers.alarmTest,
          alarmClock: alarmClock,
          allowWhileIdle: allowWhileIdle,
          exact: exact,
          wakeup: wakeup,
          rescheduleOnReboot: rescheduleOnReboot,
        );

        expect(result, isTrue);
      });
    });

    group('oneShot', () {
      test('sends arguments to the device', () async {
        const delay = Duration(milliseconds: 100);
        const id = 1;
        const alarmClock = true;
        const allowWhileIdle = true;
        const exact = true;
        const wakeup = true;
        const rescheduleOnReboot = true;

        final result = await AndroidAlarmManager.oneShot(
          delay,
          id,
          AlarmHelpers.alarmTest,
          alarmClock: alarmClock,
          allowWhileIdle: allowWhileIdle,
          exact: exact,
          wakeup: wakeup,
          rescheduleOnReboot: rescheduleOnReboot,
        );

        expect(result, isTrue);
      });

      testWidgets('callback is called', (WidgetTester tester) async {
        await tester.runAsync(() async {
          WidgetsFlutterBinding.ensureInitialized();

          // Register the UI isolate's SendPort to allow for communication from the
          // background isolate.
          port = ReceivePort();
          IsolateNameServer.registerPortWithName(
            port.sendPort,
            isolateName,
          );

          await tester.pumpWidget(const AlarmManagerExampleApp());
          await tester.tap(find.byKey(const ValueKey('RegisterOneShotAlarm')));
          await tester.pumpAndSettle();

          // 10 seconds is the smallest amount of time we need to wait for
          // the callback to happen
          await Future.delayed(const Duration(seconds: 10));
          await tester.pumpAndSettle();

          expect(
            find.byWidgetPredicate(
              (Widget widget) =>
                  widget is Text &&
                  widget.data!.startsWith('Alarm fired 1 times'),
              skipOffstage: false,
            ),
            findsOneWidget,
          );
        });
      }, skip: true /*fails on CI, works locally*/);
    });

    group('periodic', () {
      test('validates input', () async {
        const validDuration = Duration(seconds: 0);
        const validId = 1;

        // Callback should take a single int param.
        await expectLater(
          () => AndroidAlarmManager.periodic(
            validDuration,
            validId,
            invalidCallback,
          ),
          throwsAssertionError,
        );

        // ID should be less than 32 bits.
        await expectLater(
          () => AndroidAlarmManager.periodic(
            validDuration,
            2147483648,
            validCallback,
          ),
          throwsAssertionError,
        );
      });

      test('sends arguments to the device', () async {
        const id = 1;
        const allowWhileIdle = true;
        const exact = true;
        const wakeup = true;
        const rescheduleOnReboot = true;
        const period = Duration(seconds: 1);

        final result = await AndroidAlarmManager.periodic(
          period,
          id,
          AlarmHelpers.alarmTest,
          allowWhileIdle: allowWhileIdle,
          exact: exact,
          wakeup: wakeup,
          rescheduleOnReboot: rescheduleOnReboot,
        );

        expect(result, isTrue);
      });
    });

    group('cancel', () {
      test('cancels the alarm by id', () async {
        const delay = Duration(seconds: 2);
        const id = 1;
        const alarmClock = true;
        const allowWhileIdle = true;
        const exact = true;
        const wakeup = true;
        const rescheduleOnReboot = true;

        AndroidAlarmManager.oneShot(
          delay,
          id,
          AlarmHelpers.alarmTest,
          alarmClock: alarmClock,
          allowWhileIdle: allowWhileIdle,
          exact: exact,
          wakeup: wakeup,
          rescheduleOnReboot: rescheduleOnReboot,
        );

        final canceled = await AndroidAlarmManager.cancel(id);

        expect(canceled, isTrue);
      });
    });
  });
}
