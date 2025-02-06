// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:package_info_plus_example/main.dart';

const android14SDK = 34;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final testStartTime = DateTime.now();

  testWidgets('fromPlatform', (WidgetTester tester) async {
    final info = await PackageInfo.fromPlatform();
    // These tests are based on the example app. The tests should be updated if any related info changes.
    if (kIsWeb) {
      expect(info.appName, 'package_info_plus_example');
      expect(info.buildNumber, '4');
      expect(info.buildSignature, isEmpty);
      expect(info.packageName, 'package_info_plus_example');
      expect(info.version, '1.2.3');
      expect(info.installerStore, null);
      expect(info.installTime, null);
      expect(info.updateTime, null);
    } else {
      if (Platform.isAndroid) {
        final androidVersionInfo = await DeviceInfoPlugin().androidInfo;

        expect(info.appName, 'package_info_example');
        expect(info.buildNumber, '4');
        expect(info.buildSignature, isNotEmpty);
        expect(info.packageName, 'io.flutter.plugins.packageinfoexample');
        expect(info.version, '1.2.3');
        // Since Android 14 (API 34) OS returns com.android.shell when app is installed via package installer
        if (androidVersionInfo.version.sdkInt >= android14SDK) {
          expect(info.installerStore, 'com.android.shell');
        } else {
          expect(info.installerStore, null);
        }
        expect(
          info.installTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just installed',
            lessThanOrEqualTo(1),
          ),
        );
        expect(
          info.updateTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just updated',
            lessThanOrEqualTo(1),
          ),
        );
      } else if (Platform.isIOS) {
        expect(info.appName, 'Package Info Plus Example');
        expect(info.buildNumber, '4');
        expect(info.buildSignature, isEmpty);
        expect(info.packageName, 'io.flutter.plugins.packageInfoExample');
        expect(info.version, '1.2.3');
        expect(info.installerStore, 'com.apple.simulator');
        expect(
          info.installTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just installed',
            lessThanOrEqualTo(1),
          ),
        );
        expect(
          info.updateTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just updated',
            lessThanOrEqualTo(1),
          ),
        );
      } else if (Platform.isMacOS) {
        expect(info.appName, 'Package Info Plus Example');
        expect(info.buildNumber, '4');
        expect(info.buildSignature, isEmpty);
        expect(info.packageName, 'io.flutter.plugins.packageInfoExample');
        expect(info.version, '1.2.3');
        expect(info.installerStore, null);
        expect(
          info.installTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just installed',
            lessThanOrEqualTo(1),
          ),
        );
        expect(
          info.updateTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just updated',
            lessThanOrEqualTo(1),
          ),
        );
      } else if (Platform.isLinux) {
        expect(info.appName, 'package_info_plus_example');
        expect(info.buildNumber, '4');
        expect(info.buildSignature, isEmpty);
        expect(info.packageName, 'package_info_plus_example');
        expect(info.version, '1.2.3');
        expect(
          info.installTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just installed',
            lessThanOrEqualTo(1),
          ),
        );
        expect(
          info.updateTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just updated',
            lessThanOrEqualTo(1),
          ),
        );
      } else if (Platform.isWindows) {
        expect(info.appName, 'example');
        expect(info.buildNumber, '4');
        expect(info.buildSignature, isEmpty);
        expect(info.packageName, 'example');
        expect(info.version, '1.2.3');
        expect(info.installerStore, null);
        expect(
          info.installTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just installed',
            lessThanOrEqualTo(1),
          ),
        );
        expect(
          info.updateTime,
          isA<DateTime>().having(
            (d) => d.difference(DateTime.now()).inMinutes,
            'Was just updated',
            lessThanOrEqualTo(1),
          ),
        );
      } else {
        throw (UnsupportedError('platform not supported'));
      }
    }
  });

  testWidgets('example', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    if (kIsWeb) {
      expect(find.text('package_info_plus_example'), findsNWidgets(2));
      expect(find.text('1.2.3'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Not set'), findsOneWidget);
      expect(find.text('not available'), findsOneWidget);
      expect(find.text('Install time not available'), findsOneWidget);
      expect(find.text('Update time not available'), findsOneWidget);
    } else {
      final expectedInstallTimeIso = testStartTime.toIso8601String();
      final installTimeRegex = RegExp(
        expectedInstallTimeIso.replaceAll(
          RegExp(r'\d:\d\d\..+$'),
          r'.+$',
        ),
      );

      if (Platform.isAndroid) {
        final androidVersionInfo = await DeviceInfoPlugin().androidInfo;

        expect(find.text('package_info_example'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(
          find.text('io.flutter.plugins.packageinfoexample'),
          findsOneWidget,
        );
        expect(find.text('1.2.3'), findsOneWidget);
        expect(find.text('Not set'), findsNothing);
        // Since Android 14 (API 34) OS returns com.android.shell when app is installed via package installer
        if (androidVersionInfo.version.sdkInt >= android14SDK) {
          expect(find.text('com.android.shell'), findsOneWidget);
        } else {
          expect(find.text('not available'), findsOneWidget);
        }
        expect(find.textContaining(installTimeRegex), findsNWidgets(2));
      } else if (Platform.isIOS) {
        expect(find.text('Package Info Plus Example'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(
            find.text('io.flutter.plugins.packageInfoExample'), findsOneWidget);
        expect(find.text('1.2.3'), findsOneWidget);
        expect(find.text('Not set'), findsOneWidget);
        expect(find.text('com.apple.simulator'), findsOneWidget);
        expect(find.textContaining(installTimeRegex), findsNWidgets(2));
      } else if (Platform.isMacOS) {
        expect(find.text('Package Info Plus Example'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(
            find.text('io.flutter.plugins.packageInfoExample'), findsOneWidget);
        expect(find.text('1.2.3'), findsOneWidget);
        expect(find.text('Not set'), findsOneWidget);
        expect(find.text('not available'), findsOneWidget);
        expect(find.textContaining(installTimeRegex), findsNWidgets(2));
      } else if (Platform.isLinux) {
        expect(find.text('package_info_plus_example'), findsNWidgets(2));
        expect(find.text('1.2.3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('Not set'), findsOneWidget);
        expect(find.textContaining(installTimeRegex), findsNWidgets(2));
      } else if (Platform.isWindows) {
        expect(find.text('example'), findsNWidgets(2));
        expect(find.text('1.2.3'), findsOneWidget);
        expect(find.text('4'), findsOneWidget);
        expect(find.text('Not set'), findsOneWidget);
        expect(find.text('not available'), findsOneWidget);
        expect(find.textContaining(installTimeRegex), findsNWidgets(2));
      } else {
        throw (UnsupportedError('platform not supported'));
      }
    }
  });
}
