import 'package:device_info_plus_platform_interface/model/linux_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$LinuxDeviceInfo', () {
    test('toMap should return map with correct key and map', () {
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

      expect(linuxDeviceInfo.toMap(), {
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
      });
    });
  });
}
