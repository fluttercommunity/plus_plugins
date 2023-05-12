// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus_platform_interface/method_channel_connectivity.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelConnectivity', () {
    final log = <MethodCall>[];
    late MethodChannelConnectivity methodChannelConnectivity;

    setUp(() async {
      methodChannelConnectivity = MethodChannelConnectivity();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        methodChannelConnectivity.methodChannel,
        (MethodCall methodCall) async {
          log.add(methodCall);
          switch (methodCall.method) {
            case 'check':
              return 'wifi';
            default:
              return null;
          }
        },
      );
      log.clear();

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        MethodChannel(methodChannelConnectivity.eventChannel.name),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'listen':
              await TestDefaultBinaryMessengerBinding
                  .instance.defaultBinaryMessenger
                  .handlePlatformMessage(
                methodChannelConnectivity.eventChannel.name,
                methodChannelConnectivity.eventChannel.codec
                    .encodeSuccessEnvelope('wifi'),
                (_) {},
              );
              break;
            case 'cancel':
            default:
              return null;
          }
          return null;
        },
      );
    });

    test('onConnectivityChanged', () async {
      final result =
          await methodChannelConnectivity.onConnectivityChanged.first;
      expect(result, ConnectivityResult.wifi);
    });

    test('checkConnectivity', () async {
      final result = await methodChannelConnectivity.checkConnectivity();
      expect(result, ConnectivityResult.wifi);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'check',
            arguments: null,
          ),
        ],
      );
    });
  });
}
