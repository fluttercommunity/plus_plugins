import 'dart:convert';

import 'package:device_info_plus_platform_interface/model/linux_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$LinuxDeviceInfo', () {
    const linuxDeviceInfoMap = <String, Object?>{
      'name': 'name',
      'version': 'version',
      'id': 'id',
      'idLike': ['idLike'],
      'versionCodename': 'versionCodename',
      'versionId': 'versionId',
      'prettyName': 'prettyName',
      'buildId': 'buildId',
      'variant': 'variant',
      'variantId': 'variantId',
      'machineId': 'machineId',
    };

    final linuxDeviceInfo = LinuxDeviceInfo(
      name: 'name',
      version: 'version',
      id: 'id',
      idLike: ['idLike'],
      versionCodename: 'versionCodename',
      versionId: 'versionId',
      prettyName: 'prettyName',
      buildId: 'buildId',
      variant: 'variant',
      variantId: 'variantId',
      machineId: 'machineId',
    );
    test('toJson should return map with correct key and map', () {
      expect(linuxDeviceInfo.toJson(), linuxDeviceInfoMap);
    });
    test('jsonEncode / jsonDecode should return the correct map', () {
      final json = jsonEncode(linuxDeviceInfo);

      expect(jsonDecode(json), linuxDeviceInfoMap);
    });
  });
}
