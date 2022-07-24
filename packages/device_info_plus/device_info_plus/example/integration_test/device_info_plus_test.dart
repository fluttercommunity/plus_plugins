// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  IosDeviceInfo iosInfo;
  AndroidDeviceInfo androidInfo;
  WebBrowserInfo webBrowserInfo;
  WindowsDeviceInfo windowsInfo;
  LinuxDeviceInfo linuxInfo;
  MacOsDeviceInfo macosInfo;
  BaseDeviceInfo deviceInfo;

  setUpAll(() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (kIsWeb) {
      webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    } else {
      if (Platform.isIOS) {
        iosInfo = await deviceInfoPlugin.iosInfo;
      } else if (Platform.isAndroid) {
        androidInfo = await deviceInfoPlugin.androidInfo;
      } else if (Platform.isWindows) {
        windowsInfo = await deviceInfoPlugin.windowsInfo;
      } else if (Platform.isLinux) {
        linuxInfo = await deviceInfoPlugin.linuxInfo;
      } else if (Platform.isMacOS) {
        macosInfo = await deviceInfoPlugin.macOsInfo;
      }
    }

    deviceInfo = await deviceInfoPlugin.deviceInfo;
  });

  testWidgets('Can get non-null device model', (WidgetTester tester) async {
    if (kIsWeb) {
      expect(webBrowserInfo.userAgent, isNotNull);
      expect(deviceInfo, same(webBrowserInfo));
    } else {
      if (Platform.isIOS) {
        expect(iosInfo.model, isNotNull);
        expect(deviceInfo, same(iosInfo));
      } else if (Platform.isAndroid) {
        expect(androidInfo.model, isNotNull);
        expect(deviceInfo, same(androidInfo));
      } else if (Platform.isWindows) {
        expect(windowsInfo.computerName, isNotNull);
        expect(deviceInfo, same(windowsInfo));
      } else if (Platform.isLinux) {
        expect(linuxInfo.name, isNotNull);
        expect(deviceInfo, same(linuxInfo));
      } else if (Platform.isMacOS) {
        expect(macosInfo.computerName, isNotNull);
        expect(deviceInfo, same(macosInfo));
      }
    }
  });

  testWidgets('iphone', (WidgetTester tester) async {
    if (Platform.isIOS) {
      expect(iosInfo.name, isNotNull);
      expect(iosInfo.systemName, equals('iOS'));
      expect(iosInfo.systemVersion, isNotNull);
      expect(iosInfo.model, equals('iPhone'));
      expect(iosInfo.localizedModel, equals('iPhone'));

      expect(iosInfo.identifierForVendor, isNotNull);
      expect(iosInfo.isPhysicalDevice, isNotNull);

      expect(iosInfo.utsname.sysname, equals('Darwin'));
      expect(iosInfo.utsname.nodename, isNotNull);
      expect(iosInfo.utsname.release, isNotNull);
      expect(iosInfo.utsname.version, isNotNull);
      expect(iosInfo.utsname.machine, isNotNull);
    }
  });

  testWidgets('android', (WidgetTester tester) async {
    if (Platform.isAndroid) {
      expect(androidInfo.version.baseOS, isNotNull);
      expect(androidInfo.version.codename, isNotNull);
      expect(androidInfo.version.incremental, isNotNull);
      expect(androidInfo.version.previewSdkInt, isNotNull);
      expect(androidInfo.version.release, isNotNull);
      expect(isInteger(androidInfo.version.sdkInt), true);
      expect(androidInfo.version.securityPatch, isNotNull);

      expect(androidInfo.board, isNotNull);
      expect(androidInfo.bootloader, isNotNull);
      expect(androidInfo.brand, isNotNull);
      expect(androidInfo.device, isNotNull);
      expect(androidInfo.display, isNotNull);
      expect(androidInfo.fingerprint, isNotNull);
      expect(androidInfo.hardware, isNotNull);

      expect(androidInfo.host, isNotNull);
      expect(androidInfo.id, isNotNull);
      expect(androidInfo.manufacturer, isNotNull);
      expect(androidInfo.model, isNotNull);
      expect(androidInfo.product, isNotNull);

      expect(androidInfo.supported32BitAbis, isNotNull);
      expect(androidInfo.supported64BitAbis, isNotNull);
      expect(androidInfo.supportedAbis, isNotNull);

      expect(androidInfo.tags, isNotNull);
      expect(androidInfo.type, isNotNull);
      expect(androidInfo.isPhysicalDevice, isNotNull);
      expect(androidInfo.androidId, isNull);
      expect(androidInfo.systemFeatures, isNotNull);
    }
  });

  testWidgets('Windows', (WidgetTester tester) async {
    if (Platform.isWindows) {
      expect(windowsInfo.computerName, isNotNull);
      expect(windowsInfo.numberOfCores, isNotNull);
      expect(windowsInfo.systemMemoryInMegabytes, isNotNull);
    }
  });
}

bool isInteger(num value) =>
    value is int || value == value.roundToDouble() || value != null;

bool isString(String value) => value != null;
