// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // NOTE: The accelerometer events are not returned on iOS simulators.
  testWidgets('Can subscribe to accelerometerEvents and get non-null events',
      (WidgetTester tester) async {
    final completer = Completer<AccelerometerEvent>();
    late StreamSubscription<AccelerometerEvent> subscription;
    subscription =
        accelerometerEventStream().listen((AccelerometerEvent event) {
      completer.complete(event);
      subscription.cancel();
    });
    expect(await completer.future, isNotNull);
  }, skip: !Platform.isAndroid);
}
