// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Connectivity connectivity;

  group('Connectivity test driver', () {
    setUpAll(() async {
      connectivity = Connectivity();
    });

    testWidgets('test connectivity result', (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();
      expect(result, isNotNull);
    });

    testWidgets('connectivity on Android newer than 5 (API 21) should be wifi',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.wifi);
    },
        skip: !Platform.isAndroid ||
            Platform.operatingSystemVersion.contains('5.0.2'));

    testWidgets('connectivity on Android 5 (API 21) should be mobile',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.mobile);
    },
        skip: !Platform.isAndroid ||
            !Platform.operatingSystemVersion.contains('5.0.2'));

    testWidgets('connectivity on MacOS should be ethernet',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.ethernet);
    }, skip: !Platform.isMacOS);

    testWidgets('connectivity on Linux should be none',
        (WidgetTester tester) async {
      final result = await connectivity.checkConnectivity();

      expect(result, ConnectivityResult.other);
    }, skip: !Platform.isLinux);
  });
}
