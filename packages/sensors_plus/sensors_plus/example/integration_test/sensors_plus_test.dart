// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can subscribe to accelerometerEvents and get non-null events',
      (WidgetTester tester) async {
    final completer = Completer<AccelerometerEvent>();
    StreamSubscription<AccelerometerEvent> subscription;
    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    expect(await completer.future, isNotNull);
  });

  testWidgets('Can subscribe to gyroscopeEvents and get non-null events',
      (WidgetTester tester) async {
    final completer = Completer<GyroscopeEvent>();
    StreamSubscription<GyroscopeEvent> subscription;
    subscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    expect(await completer.future, isNotNull);
  });

  testWidgets('Can subscribe to gyroscopeEvents and get expected events',
      (WidgetTester tester) async {
    final completer = Completer<GyroscopeEvent>();
    StreamSubscription<GyroscopeEvent> subscription;
    subscription = gyroscopeEvents.listen((GyroscopeEvent event) {
      completer.complete(event);
      subscription.cancel();
    });

    final event = await completer.future;
    expect(event.toString(), GyroscopeEvent(0, 0, 0).toString());
  }, skip: !Platform.isAndroid);

  testWidgets(
      'Can subscribe to userAccelerometerEvents and get non-null events',
      (WidgetTester tester) async {
    final completer = Completer<UserAccelerometerEvent>();
    StreamSubscription<UserAccelerometerEvent> subscription;
    subscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    expect(await completer.future, isNotNull);
  });

  testWidgets('Can subscribe to magnetometerEvent and get non-null events',
      (WidgetTester tester) async {
    final completer = Completer<MagnetometerEvent>();
    StreamSubscription<MagnetometerEvent> subscription;
    subscription = magnetometerEvents.listen((MagnetometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    expect(await completer.future, isNotNull);
  });
}
