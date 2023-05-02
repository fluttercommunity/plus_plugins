@TestOn('windows')
library package_info_plus_windows_test;

import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/src/file_version_info.dart';
import 'package:package_info_plus/src/package_info_plus_windows.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

void main() {
  test('registered instance', () {
    PackageInfoPlusWindowsPlugin.registerWith();
    expect(PackageInfoPlatform.instance, isA<PackageInfoPlusWindowsPlugin>());
  });

  test('File version info works for standard Windows DLL', () {
    // Every valid Windows release should have this file
    final kernelVersion = FileVersionInfo('%WINDIR%\\System32\\kernel32.dll');
    expect(kernelVersion.productName?.indexOf('Windows'), greaterThan(-1));
    expect(kernelVersion.productVersion, isNotNull);
    kernelVersion.dispose();
  });
}
