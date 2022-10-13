//@dart=2.9

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Connectivity test driver', () {
    Connectivity connectivity;

    setUpAll(() async {
      connectivity = Connectivity();
    });

    testWidgets('test connectivity result', (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();
      expect(result, isNotNull);
    });

    testWidgets('connectivity on Android emulator should be wifi',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.wifi);
    }, skip: !Platform.isAndroid);

    testWidgets('connectivity on MacOS should be ethernet',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.ethernet);
    }, skip: !Platform.isMacOS);

    testWidgets('connectivity on Linux should be none',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.none);
    }, skip: !Platform.isLinux);
  });
}
