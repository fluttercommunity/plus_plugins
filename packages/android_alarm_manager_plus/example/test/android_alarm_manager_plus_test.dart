// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:android_alarm_manager_example/main.dart';


Future<void> main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Android alarm manager example app loads', (WidgetTester tester) async {
    await tester.pumpWidget(const AlarmManagerExampleApp());

  });
    // Build our app and trigger a frame.


}
