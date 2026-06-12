// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus_environment.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.fluttercommunity.plus/package_info');
  final log = <MethodCall>[];

  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
        log.add(methodCall);
        return <String, dynamic>{
          'appName': 'package_info_example',
          'buildNumber': '1',
          'packageName': 'io.flutter.plugins.packageinfoexample',
          'version': '1.0',
        };
      });

  tearDown(log.clear);

  // Off the web (these tests run on the Dart VM), the accessor delegates to
  // PackageInfo.fromPlatform(). The web path is enforced at compile time and is
  // covered by a compile test rather than a runtime test — a web build that
  // omits PACKAGE_INFO_PLUS_VERSION does not compile.
  test(
    'packageInfo delegates to fromPlatform on non-web platforms',
    () async {
      final info = await PackageInfoEnvironment.packageInfo;
      expect(info.version, '1.0');
      expect(info.appName, 'package_info_example');
      expect(info.packageName, 'io.flutter.plugins.packageinfoexample');
      expect(info.buildNumber, '1');
      expect(log, <Matcher>[isMethodCall('getAll', arguments: null)]);
    },
    onPlatform: {'browser': const Skip('Web path is compile-time enforced')},
  );
}
