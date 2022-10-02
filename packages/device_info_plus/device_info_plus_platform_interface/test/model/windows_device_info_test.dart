// ignore_for_file: deprecated_member_use_from_same_package

import 'package:device_info_plus_platform_interface/model/windows_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$WindowsDeviceInfo', () {
    test('toMap should return map with correct key and map', () {
      final windowsDeviceInfo = WindowsDeviceInfo(
        computerName: 'computerName',
        numberOfCores: 4,
        systemMemoryInMegabytes: 16,
      );

      expect(windowsDeviceInfo.toMap(), {
        'computerName': 'computerName',
        'numberOfCores': 4,
        'systemMemoryInMegabytes': 16,
      });
    });
  });
}
