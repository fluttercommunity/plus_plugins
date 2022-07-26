// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// @dart=2.9

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/method_channel_network_info.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkInfo test driver', () {
    final log = <MethodCall>[];
    NetworkInfo _networkInfo;
    MethodChannelNetworkInfo _methodChannelNetworkInfo;

    setUpAll(() async {
      _networkInfo = NetworkInfo();
      _methodChannelNetworkInfo = MethodChannelNetworkInfo();

      _methodChannelNetworkInfo.methodChannel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'wifiName':
            return '1337wifi';
          case 'wifiBSSID':
            return 'c0:ff:33:c0:d3:55';
          case 'wifiIPAddress':
            return '127.0.0.1';
          case 'wifiIPv6Address':
            return '2002:7f00:0001:0:0:0:0:0';
          case 'wifiBroadcast':
            return '127.0.0.255';
          case 'wifiGatewayAddress':
            return '127.0.0.0';
          case 'wifiSubmask':
            return '255.255.255.0';
          case 'requestLocationServiceAuthorization':
            return 'authorizedAlways';
          case 'getLocationServiceAuthorization':
            return 'authorizedAlways';
          default:
            return null;
        }
      });
      log.clear();
    });

    testWidgets('test location methods, iOS only', (WidgetTester tester) async {
      if (Platform.isIOS) {
        expect((await _networkInfo.getLocationServiceAuthorization()),
            LocationAuthorizationStatus.notDetermined);
      }
    }, skip: !Platform.isAndroid);

    testWidgets('test non-null network value', (WidgetTester tester) async {
      expect(_networkInfo.getWifiName(), isNotNull);
      expect(_networkInfo.getWifiBSSID(), isNotNull);
      expect(_networkInfo.getWifiIP(), isNotNull);
      expect(_networkInfo.getWifiIPv6(), isNotNull);
      expect(_networkInfo.getWifiSubmask(), isNotNull);
      expect(_networkInfo.getWifiGatewayIP(), isNotNull);
      expect(_networkInfo.getWifiBroadcast(), isNotNull);
    }, skip: !Platform.isAndroid);

    testWidgets('test fixed network value', (WidgetTester tester) async {
      final result = await _methodChannelNetworkInfo.getWifiSubmask();
      expect(result, '255.255.255.0');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiSubmask',
            arguments: null,
          ),
        ],
      );
    }, skip: !Platform.isAndroid);
  });
}
