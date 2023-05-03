@TestOn('windows')
library device_info_plus_windows_test;

import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registered instance', () {
    DeviceInfoPlusWindowsPlugin.registerWith();
    expect(DeviceInfoPlatform.instance, isA<DeviceInfoPlusWindowsPlugin>());
  });
  test('system-memory-in-megabytes', () async {
    final systemMemoryInMegabytes =
        DeviceInfoPlusWindowsPlugin().getSystemMemoryInMegabytes();
    // Must be a non-negative integer value.
    expect(systemMemoryInMegabytes, isPositive);
  });
  test('computer-name', () async {
    final computerName = DeviceInfoPlusWindowsPlugin().getComputerName();
    // Must be a non-empty string value.
    expect(computerName, isNotEmpty);
  });
  test('user-name', () async {
    final userName = DeviceInfoPlusWindowsPlugin().getUserName();
    // Must be a non-empty string value.
    expect(userName, isNotEmpty);
  });
  test('windows information', () async {
    final deviceInfo = DeviceInfoPlusWindowsPlugin();
    final windowsInfo = (await deviceInfo.deviceInfo()) as WindowsDeviceInfo;
    // Check whether windowsInfo.numberOfProcessors is an integer.
    expect(windowsInfo.numberOfCores, isA<int>());
    // Check whether windowsInfo.computerName is a valid non-empty string.
    expect(windowsInfo.computerName, isA<String>());
    expect(windowsInfo.computerName, isNotEmpty);
    // Check whether windowsInfo.systemMemoryInMegabytes is an integer.
    expect(windowsInfo.systemMemoryInMegabytes, isA<int>());
    // Check whether windowsInfo.userName is a valid non-empty string.
    expect(windowsInfo.userName, isA<String>());
    expect(windowsInfo.userName, isNotEmpty);
    // Check for Windows 10 or greater.
    expect(windowsInfo.majorVersion, equals(10));
    expect(windowsInfo.minorVersion, equals(0));
    expect(windowsInfo.buildNumber, greaterThan(10240));
    // The value should always be 2 on Windows (VER_PLATFORM_WIN32_NT).
    expect(windowsInfo.platformId, equals(2));
    // Check whether windowsInfo.csdVersion is a string.
    expect(windowsInfo.csdVersion, isA<String>());
    // Check whether windowsInfo.servicePackMajor is an integer.
    expect(windowsInfo.servicePackMajor, isA<int>());
    // Check whether windowsInfo.servicePackMinor is an integer.
    expect(windowsInfo.servicePackMinor, isA<int>());
    // Check whether windowsInfo.suitMask is an integer.
    expect(windowsInfo.suitMask, isA<int>());
    // Check whether windowsInfo.productType is an integer.
    expect(windowsInfo.productType, isA<int>());
    // Check whether windowsInfo.reserved is zero.
    expect(windowsInfo.reserved, isZero);
    // Check whether windowsInfo.buildLab is a valid non-empty string & starts with windowsInfo.buildNumber.
    expect(windowsInfo.buildLab, isA<String>());
    expect(windowsInfo.buildLab, isNotEmpty);
    expect(
      windowsInfo.buildLab,
      startsWith(windowsInfo.buildNumber.toString()),
    );
    // Check whether windowsInfo.buildLabEx is a valid non-empty string & starts with windowsInfo.buildNumber.
    expect(windowsInfo.buildLab, isA<String>());
    expect(windowsInfo.buildLabEx, isNotEmpty);
    expect(
      windowsInfo.buildLab,
      startsWith(windowsInfo.buildNumber.toString()),
    );
    // Check whether windowsInfo.digitalProductId is a Uint8List.
    expect(windowsInfo.digitalProductId, isA<Uint8List>());
    expect(windowsInfo.digitalProductId, isNotEmpty);
    // Check whether windowsInfo.editionId is a valid non-empty string.
    expect(windowsInfo.editionId, isA<String>());
    expect(windowsInfo.editionId, isNotEmpty);
    // Check whether windowsInfo.installDate is a valid date.
    expect(windowsInfo.installDate, isA<DateTime>());
    // Check whether windowsInfo.productId is a valid non-empty string & matches 00000-00000-00000-AAAAA format.
    expect(windowsInfo.productId, isA<String>());
    expect(windowsInfo.productId, isNotEmpty);
    expect(
      windowsInfo.productId,
      matches(RegExp(r'^([A-Z0-9]{5}-){3}[A-Z0-9]{5}$')),
    );
    // Check whether windowsInfo.productName is a valid non-empty string & starts with "Windows".
    expect(windowsInfo.productName, isA<String>());
    expect(windowsInfo.productName, isNotEmpty);
    expect(windowsInfo.productName, startsWith('Windows'));
    // Check whether windowsInfo.registeredOwner is a valid non-empty string.
    expect(windowsInfo.registeredOwner, isA<String>());
    expect(windowsInfo.registeredOwner, isNotEmpty);
    // Check whether windowsInfo.releaseId is a valid non-empty string.
    expect(windowsInfo.releaseId, isA<String>());
    expect(windowsInfo.releaseId, isNotEmpty);
    // Check whether windowsInfo.deviceId is a valid non-empty string.
    expect(windowsInfo.deviceId, isA<String>());
    expect(windowsInfo.deviceId, isNotEmpty);
  });
}
