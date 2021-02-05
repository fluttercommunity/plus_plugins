// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

  setUpAll(() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      iosInfo = await deviceInfoPlugin.iosInfo;
    } else if (Platform.isAndroid) {
      androidInfo = await deviceInfoPlugin.androidInfo;
    } else if (Platform.isWindows) {
      windowsInfo = await deviceInfoPlugin.windowsInfo;
    }

    if (kIsWeb) {
      webBrowserInfo = await deviceInfoPlugin.webBrowserInfo;
    }
  });

  testWidgets('Can get non-null device model', (WidgetTester tester) async {
    if (Platform.isIOS) {
      expect(iosInfo.model, isNotNull);
    } else if (Platform.isAndroid) {
      expect(androidInfo.model, isNotNull);
    } else if (Platform.isWindows) {
      expect(windowsInfo.computerName, isNotNull);
    }

    if (kIsWeb) {
      expect(webBrowserInfo.userAgent, isNotNull);
    }
  });
}
