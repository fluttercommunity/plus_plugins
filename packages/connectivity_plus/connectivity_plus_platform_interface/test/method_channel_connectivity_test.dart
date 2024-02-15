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
              // Simulate returning a list of string of connectivity statuses
              return ['wifi', 'mobile'];
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
              // Simulate returning a comma-separated string of connectivity statuses
              await TestDefaultBinaryMessengerBinding
                  .instance.defaultBinaryMessenger
                  .handlePlatformMessage(
                methodChannelConnectivity.eventChannel.name,
                methodChannelConnectivity.eventChannel.codec
                    .encodeSuccessEnvelope(['wifi', 'mobile']),
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

    // Test adjusted to handle multiple connectivity types
    test('onConnectivityChanged', () async {
      final result =
          await methodChannelConnectivity.onConnectivityChanged.first;
      expect(result,
          containsAll([ConnectivityResult.wifi, ConnectivityResult.mobile]));
    });

    // Test adjusted to handle multiple connectivity types
    test('checkConnectivity', () async {
      final result = await methodChannelConnectivity.checkConnectivity();
      expect(result,
          containsAll([ConnectivityResult.wifi, ConnectivityResult.mobile]));
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
