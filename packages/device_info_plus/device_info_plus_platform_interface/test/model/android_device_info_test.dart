import 'package:device_info_plus_platform_interface/model/android_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$AndroidDeviceInfo', () {
    group('fromMap | toMap', () {
      const androidBuildVersionMap = <String, dynamic>{
        'sdkInt': 16,
        'baseOS': 'baseOS',
        'previewSdkInt': 30,
        'release': 'release',
        'codename': 'codename',
        'incremental': 'incremental',
        'securityPatch': 'securityPatch',
      };
      const supportedAbis = <String>['arm64-v8a', 'x86', 'x86_64'];
      const supported32BitAbis = <String?>['x86 (IA-32)', 'MMX'];
      const supported64BitAbis = <String?>['x86-64', 'MMX', 'SSSE3'];
      const systemFeatures = ['FEATURE_AUDIO_PRO', 'FEATURE_AUDIO_OUTPUT'];
      final androidDeviceInfoMap = <String, dynamic>{
        'id': 'id',
        'host': 'host',
        'tags': 'tags',
        'type': 'type',
        'model': 'model',
        'board': 'board',
        'brand': 'brand',
        'device': 'device',
        'product': 'product',
        'display': 'display',
        'hardware': 'hardware',
        'androidId': 'androidId',
        'isPhysicalDevice': true,
        'bootloader': 'bootloader',
        'fingerprint': 'fingerprint',
        'manufacturer': 'manufacturer',
        'supportedAbis': supportedAbis,
        'systemFeatures': systemFeatures,
        'version': androidBuildVersionMap,
        'supported64BitAbis': supported64BitAbis,
        'supported32BitAbis': supported32BitAbis,
      };

      test('fromMap should return $AndroidDeviceInfo with correct values', () {
        final androidDeviceInfo =
            AndroidDeviceInfo.fromMap(androidDeviceInfoMap);

        expect(androidDeviceInfo.id, 'id');
        expect(androidDeviceInfo.host, 'host');
        expect(androidDeviceInfo.tags, 'tags');
        expect(androidDeviceInfo.type, 'type');
        expect(androidDeviceInfo.model, 'model');
        expect(androidDeviceInfo.board, 'board');
        expect(androidDeviceInfo.brand, 'brand');
        expect(androidDeviceInfo.device, 'device');
        expect(androidDeviceInfo.product, 'product');
        expect(androidDeviceInfo.display, 'display');
        expect(androidDeviceInfo.hardware, 'hardware');
        expect(androidDeviceInfo.androidId, 'androidId');
        expect(androidDeviceInfo.bootloader, 'bootloader');
        expect(androidDeviceInfo.isPhysicalDevice, isTrue);
        expect(androidDeviceInfo.fingerprint, 'fingerprint');
        expect(androidDeviceInfo.manufacturer, 'manufacturer');
        expect(androidDeviceInfo.supportedAbis, supportedAbis);
        expect(androidDeviceInfo.systemFeatures, systemFeatures);
        expect(androidDeviceInfo.supported32BitAbis, supported32BitAbis);
        expect(androidDeviceInfo.supported64BitAbis, supported64BitAbis);
        expect(androidDeviceInfo.version.sdkInt, 16);
        expect(androidDeviceInfo.version.baseOS, 'baseOS');
        expect(androidDeviceInfo.version.previewSdkInt, 30);
        expect(androidDeviceInfo.version.release, 'release');
        expect(androidDeviceInfo.version.codename, 'codename');
        expect(androidDeviceInfo.version.incremental, 'incremental');
        expect(androidDeviceInfo.version.securityPatch, 'securityPatch');
      });

      test('toMap should return map with correct key and map', () {
        final androidDeviceInfo =
            AndroidDeviceInfo.fromMap(androidDeviceInfoMap);

        expect(androidDeviceInfo.toJson(), androidDeviceInfoMap);
      });
    });
  });
}
