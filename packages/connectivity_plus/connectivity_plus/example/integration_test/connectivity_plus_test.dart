//@dart=2.9

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Connectivity test driver', () {
    Connectivity _connectivity;
    ConnectivityResult _connectionStatusExpected = ConnectivityResult.wifi;

    setUpAll(() async {
      _connectivity = Connectivity();
    });

    testWidgets('test connectivity result', (WidgetTester tester) async {
      final result = await _connectivity.checkConnectivity();
      expect(result, isNotNull);
    });

    testWidgets('test wifi or cellular', (WidgetTester tester) async {
      final result = await _connectivity.checkConnectivity();

      StreamSubscription<ConnectivityResult> _connectivitySubscription;
      // _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

      ConnectivityResult _connectionStatus = ConnectivityResult.none;
      _connectionStatus = result;

      expect(_connectionStatus, equals(_connectionStatusExpected));
    });
  });
}
