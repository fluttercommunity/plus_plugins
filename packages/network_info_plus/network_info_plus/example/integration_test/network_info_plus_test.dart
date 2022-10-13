// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:network_info_plus/network_info_plus.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkInfo test driver', () {
    NetworkInfo networkInfo;

    setUpAll(() async {
      networkInfo = NetworkInfo();
    });

    testWidgets('test location methods, iOS only', (WidgetTester tester) async {
      if (Platform.isIOS) {
        expect((await networkInfo.getLocationServiceAuthorization()), LocationAuthorizationStatus.notDetermined);
      }
    }, skip: !Platform.isIOS);

    testWidgets('test non-null network value', (WidgetTester tester) async {
      expect(networkInfo.getWifiName(), isNotNull);
      expect(networkInfo.getWifiBSSID(), isNotNull);
      expect(networkInfo.getWifiIP(), isNotNull);
      expect(networkInfo.getWifiIPv6(), isNotNull);
      expect(networkInfo.getWifiSubmask(), isNotNull);
      expect(networkInfo.getWifiGatewayIP(), isNotNull);
      expect(networkInfo.getWifiBroadcast(), isNotNull);
    });
  });
}
