// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show kIsWeb;
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

  // Exercises the tool-provided fallback chain on the web path. Run with:
  //
  // flutter test test/package_info_environment_test.dart --platform chrome \
  //   --dart-define=FLUTTER_BUILD_NAME=9.9.9 --dart-define=FLUTTER_BUILD_NUMBER=7
  //
  // (No PACKAGE_INFO_PLUS_VERSION: the explicit define would take precedence.)
  // Note: once flutter/flutter#187935 lands, FLUTTER_BUILD_NAME becomes
  // tool-reserved and is injected automatically instead of being passed by hand.
  test(
    'web path falls back to the tool-provided FLUTTER_BUILD_NAME defines',
    () async {
      if (!kIsWeb) return;
      final info = await PackageInfoEnvironment.packageInfo;
      expect(info.version, const String.fromEnvironment('FLUTTER_BUILD_NAME'));
      expect(
        info.buildNumber,
        const String.fromEnvironment('FLUTTER_BUILD_NUMBER'),
      );
    },
    skip:
        const bool.hasEnvironment('PACKAGE_INFO_PLUS_VERSION') ||
            !const bool.hasEnvironment('FLUTTER_BUILD_NAME')
        ? 'Requires --dart-define=FLUTTER_BUILD_NAME and no '
              'PACKAGE_INFO_PLUS_VERSION (see comment above)'
        : false,
  );
}
