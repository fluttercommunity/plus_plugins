// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:device_info_plus_platform_interface/method_channel/method_channel_device_info.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelDeviceInfo', () {
    late MethodChannelDeviceInfo methodChannelDeviceInfo;

    setUp(() async {
      methodChannelDeviceInfo = MethodChannelDeviceInfo();

      methodChannelDeviceInfo.channel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getAndroidDeviceInfo':
            return ({
              'brand': 'Google',
            });
          case 'getIosDeviceInfo':
            return ({
              'name': 'iPhone 10',
            });
          case 'getMacosDeviceInfo':
            return ({
              'arch': '',
              'model': 'MacBookPro',
              'activeCPUs': 0,
              'memorySize': 0,
              'cpuFrequency': 0,
              'hostName': '',
              'osRelease': '',
              'computerName': '',
              'kernelVersion': '',
              'systemGUID': null,
            });
          default:
            return null;
        }
      });
    });

    test('androidInfo', () async {
      final result = await methodChannelDeviceInfo.androidInfo();
      expect(result.brand, 'Google');
    });

    test('iosInfo', () async {
      final result = await methodChannelDeviceInfo.iosInfo();
      expect(result.name, 'iPhone 10');
    });

    test('macosInfo', () async {
      final result = await methodChannelDeviceInfo.macosInfo();
      expect(result.model, 'MacBookPro');
    });
  });
}
