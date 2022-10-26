// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:device_info_plus_platform_interface/method_channel/method_channel_device_info.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../device_info_plus/test/model/android_device_info_fake.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelDeviceInfo', () {
    late MethodChannelDeviceInfo methodChannelDeviceInfo;

    setUp(() async {
      methodChannelDeviceInfo = MethodChannelDeviceInfo();

      methodChannelDeviceInfo.channel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getDeviceInfo':
            return {'device_info': 'is_fake'};
          default:
            return null;
        }
      });
    });

    test('deviceInfo', () async {
      final result = await methodChannelDeviceInfo.deviceInfo();
      expect(result.data['device_info'], 'is_fake');
    });
  });
}
