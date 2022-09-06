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

  // The acceleration value is +9.81, which corresponds to the acceleration of
  // the device (0 m/s^2) minus the force of gravity (-9.81 m/s^2)
  // When the device lies flat on a table.
  // You can refer to this [link](http://josejuansanchez.org/android-sensors-overview/accelerometer/README.html) for more information.
  testWidgets('Can subscribe to accelerometerEvents and get expected events',
      (WidgetTester tester) async {
    final completer = Completer<AccelerometerEvent>();
    StreamSubscription<AccelerometerEvent> subscription;
    subscription = accelerometerEvents.listen((AccelerometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });

    final event = await completer.future;
    expect(event.toString(),
        AccelerometerEvent(0.0, 9.809988975524902, 0.0).toString());
  }, skip: !Platform.isAndroid);

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

  testWidgets(
      'Can subscribe to userAccelerometerEvents and get expected events',
      (WidgetTester tester) async {
    final completer = Completer<UserAccelerometerEvent>();
    StreamSubscription<UserAccelerometerEvent> subscription;
    subscription =
        userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    final event = await completer.future;
    expect(
        event.toString(),
        UserAccelerometerEvent(0, 0.0033512115478515625, 0.0002784132957458496)
            .toString());
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
