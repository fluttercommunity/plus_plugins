// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
  final log = <MethodCall>[];

  final now = DateTime.now().copyWith(microsecond: 0);

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    channel,
    (MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getAll':
          return <String, dynamic>{
            'appName': 'package_info_example',
            'buildNumber': '1',
            'packageName': 'io.flutter.plugins.packageinfoexample',
            'version': '1.0',
            'installerStore': null,
            'installTime': now.millisecondsSinceEpoch.toString(),
          };
        default:
          assert(false);
          return null;
      }
    },
  );

  tearDown(() {
    log.clear();
  });

  test('fromPlatform', () async {
    final info = await PackageInfo.fromPlatform();
    expect(info.appName, 'package_info_example');
    expect(info.buildNumber, '1');
    expect(info.packageName, 'io.flutter.plugins.packageinfoexample');
    expect(info.version, '1.0');
    expect(info.installerStore, null);
    expect(info.installTime, now);
    expect(
      log,
      <Matcher>[
        isMethodCall('getAll', arguments: null),
      ],
    );
  }, onPlatform: {
    'linux':
        const Skip('PackageInfoPlus on Linux does not use platform channels'),
  });

  test('Mock initial values', () async {
    PackageInfo.setMockInitialValues(
      appName: 'mock_package_info_example',
      packageName: 'io.flutter.plugins.mockpackageinfoexample',
      version: '1.1',
      buildNumber: '2',
      buildSignature: 'deadbeef',
      installerStore: null,
      installTime: now,
    );
    final info = await PackageInfo.fromPlatform();
    expect(info.appName, 'mock_package_info_example');
    expect(info.buildNumber, '2');
    expect(info.packageName, 'io.flutter.plugins.mockpackageinfoexample');
    expect(info.version, '1.1');
    expect(info.buildSignature, 'deadbeef');
    expect(info.installerStore, null);
    expect(info.installTime, now);
  });

  test('equals checks for value equality', () async {
    final info1 = PackageInfo(
      appName: 'package_info_example',
      buildNumber: '1',
      packageName: 'io.flutter.plugins.packageinfoexample',
      version: '1.0',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    final info2 = PackageInfo(
      appName: 'package_info_example',
      buildNumber: '1',
      packageName: 'io.flutter.plugins.packageinfoexample',
      version: '1.0',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    expect(info1, info2);
  });

  test('hashCode checks for value equality', () async {
    final info1 = PackageInfo(
      appName: 'package_info_example',
      buildNumber: '1',
      packageName: 'io.flutter.plugins.packageinfoexample',
      version: '1.0',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    final info2 = PackageInfo(
      appName: 'package_info_example',
      buildNumber: '1',
      packageName: 'io.flutter.plugins.packageinfoexample',
      version: '1.0',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    expect(info1.hashCode, info2.hashCode);
  });

  test('toString returns a string representation', () async {
    final info = PackageInfo(
      appName: 'package_info_example',
      buildNumber: '1',
      packageName: 'io.flutter.plugins.packageinfoexample',
      version: '1.0',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    expect(
      info.toString(),
      'PackageInfo(appName: package_info_example, buildNumber: 1, packageName: io.flutter.plugins.packageinfoexample, version: 1.0, buildSignature: , installerStore: null, installTime: $now)',
    );
  });

  test('data returns a map representation', () async {
    PackageInfo.setMockInitialValues(
      appName: 'mock_package_info_example',
      packageName: 'io.flutter.plugins.mockpackageinfoexample',
      version: '1.1',
      buildNumber: '2',
      buildSignature: '',
      installerStore: null,
      installTime: now,
    );
    final info1 = await PackageInfo.fromPlatform();
    expect(info1.data, {
      'appName': 'mock_package_info_example',
      'packageName': 'io.flutter.plugins.mockpackageinfoexample',
      'version': '1.1',
      'buildNumber': '2',
      'installTime': now,
    });

    final nextWeek = now.add(const Duration(days: 7));
    PackageInfo.setMockInitialValues(
      appName: 'mock_package_info_example',
      packageName: 'io.flutter.plugins.mockpackageinfoexample',
      version: '1.1',
      buildNumber: '2',
      buildSignature: 'deadbeef',
      installerStore: 'testflight',
      installTime: nextWeek,
    );
    final info2 = await PackageInfo.fromPlatform();
    expect(info2.data, {
      'appName': 'mock_package_info_example',
      'packageName': 'io.flutter.plugins.mockpackageinfoexample',
      'version': '1.1',
      'buildNumber': '2',
      'buildSignature': 'deadbeef',
      'installerStore': 'testflight',
      'installTime': nextWeek,
    });
  });
}
