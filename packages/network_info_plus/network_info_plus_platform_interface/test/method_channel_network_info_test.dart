// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus_platform_interface/method_channel_network_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelNetworkInfo', () {
    final log = <MethodCall>[];
    late MethodChannelNetworkInfo methodChannelNetworkInfo;

    setUp(() async {
      methodChannelNetworkInfo = MethodChannelNetworkInfo();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelNetworkInfo.methodChannel,
        (MethodCall methodCall) async {
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
        },
      );
      log.clear();
    });

    test('getWifiName', () async {
      final result = await methodChannelNetworkInfo.getWifiName();
      expect(result, '1337wifi');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiName',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiBSSID', () async {
      final result = await methodChannelNetworkInfo.getWifiBSSID();
      expect(result, 'c0:ff:33:c0:d3:55');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiBSSID',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiIP', () async {
      final result = await methodChannelNetworkInfo.getWifiIP();
      expect(result, '127.0.0.1');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiIPAddress',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiIPv6', () async {
      final result = await methodChannelNetworkInfo.getWifiIPv6();
      expect(result, '2002:7f00:0001:0:0:0:0:0');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiIPv6Address',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiBroadcast', () async {
      final result = await methodChannelNetworkInfo.getWifiBroadcast();
      expect(result, '127.0.0.255');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiBroadcast',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiGatewayIP', () async {
      final result = await methodChannelNetworkInfo.getWifiGatewayIP();
      expect(result, '127.0.0.0');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'wifiGatewayAddress',
            arguments: null,
          ),
        ],
      );
    });

    test('getWifiSubmask', () async {
      final result = await methodChannelNetworkInfo.getWifiSubmask();
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
    });

    test('requestLocationServiceAuthorization', () async {
      final result =
          await methodChannelNetworkInfo.requestLocationServiceAuthorization();
      expect(result, LocationAuthorizationStatus.authorizedAlways);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'requestLocationServiceAuthorization',
            arguments: <bool>[false],
          ),
        ],
      );
    });

    test('getLocationServiceAuthorization', () async {
      final result =
          await methodChannelNetworkInfo.getLocationServiceAuthorization();
      expect(result, LocationAuthorizationStatus.authorizedAlways);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getLocationServiceAuthorization',
            arguments: null,
          ),
        ],
      );
    });
  });
}
