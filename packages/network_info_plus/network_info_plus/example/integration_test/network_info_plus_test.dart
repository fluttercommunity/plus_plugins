// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:io';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkInfo test driver', () {
    NetworkInfo _networkInfo;

    setUpAll(() async {
      _networkInfo = NetworkInfo();
    });

    testWidgets('test location methods, iOS only', (WidgetTester tester) async {
      if (Platform.isIOS) {
        expect((await _networkInfo.getLocationServiceAuthorization()),
            LocationAuthorizationStatus.notDetermined);
      }
    }, skip: !Platform.isIOS);

    testWidgets('test non-null network value', (WidgetTester tester) async {
      expect(_networkInfo.getWifiName(), isNotNull);
      expect(_networkInfo.getWifiBSSID(), isNotNull);
      expect(_networkInfo.getWifiIP(), isNotNull);
      expect(_networkInfo.getWifiIPv6(), isNotNull);
      expect(_networkInfo.getWifiSubmask(), isNotNull);
      expect(_networkInfo.getWifiGatewayIP(), isNotNull);
      expect(_networkInfo.getWifiBroadcast(), isNotNull);
    });
  });
}
