import 'dart:convert';

import 'package:device_info_plus_platform_interface/model/windows_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$WindowsDeviceInfo', () {
    final windowsDeviceInfo = WindowsDeviceInfo(
      computerName: 'computerName',
      numberOfCores: 4,
      systemMemoryInMegabytes: 16,
    );

    final windowsDeviceInfoMap = {
      'computerName': 'computerName',
      'numberOfCores': 4,
      'systemMemoryInMegabytes': 16,
    };
    test('toJson should return map with correct key and map', () {
      expect(windowsDeviceInfo.toJson(), windowsDeviceInfoMap);
    });

    test('jsonEncode / jsonDecode should return the correct map', () {
      final json = jsonEncode(windowsDeviceInfo.toJson());

      expect(jsonDecode(json), windowsDeviceInfoMap);
    });
  });
}
