// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/method_channel_package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$PackageInfoPlatform', () {
    test('$PackageInfoPlatform() is the default instance', () {
      expect(PackageInfoPlatform.instance,
          isInstanceOf<MethodChannelPackageInfo>());
    });

    test('Cannot be implemented with `implements`', () {
      expect(() {
        PackageInfoPlatform.instance = ImplementsPackageInfoPlatform();
      }, throwsA(isInstanceOf<AssertionError>()));
    });

    test('Can be mocked with `implements`', () {
      final PackageInfoPlatformMock mock = PackageInfoPlatformMock();
      PackageInfoPlatform.instance = mock;
    });

    test('Can be extended', () {
      PackageInfoPlatform.instance = ExtendsPackageInfoPlatform();
    });
  });

  group('$MethodChannelPackageInfo()', () {
    const MethodChannel channel =
        MethodChannel('dev.fluttercommunity.plus/package_info');
    final List<MethodCall> log = <MethodCall>[];
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'package_info_example',
            'buildNumber': '1',
            'packageName': 'io.flutter.plugins.packageinfoexample',
            'version': '1.0',
          };
        default:
          assert(false);
          return null;
      }
    });

    final MethodChannelPackageInfo packageInfo = MethodChannelPackageInfo();

    tearDown(() {
      log.clear();
    });

    test('getAll', () async {
      await packageInfo.getAll();
      expect(
        log,
        <Matcher>[isMethodCall('getAll', arguments: null)],
      );
    });
  });
}

class PackageInfoPlatformMock extends Mock
    with MockPlatformInterfaceMixin
    implements PackageInfoPlatform {}

class ImplementsPackageInfoPlatform extends Mock
    implements PackageInfoPlatform {}

class ExtendsPackageInfoPlatform extends PackageInfoPlatform {}
