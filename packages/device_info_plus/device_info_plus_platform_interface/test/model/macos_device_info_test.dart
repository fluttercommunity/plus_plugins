import 'package:device_info_plus_platform_interface/model/macos_device_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$MacOsDeviceInfo', () {
    group('fromMap', () {
      const macosDeviceInfoMap = <String, dynamic>{
        'arch': 'arch',
        'model': 'model',
        'activeCPUs': 4,
        'memorySize': 16,
        'cpuFrequency': 2,
        'hostName': 'hostName',
        'osRelease': 'osRelease',
        'computerName': 'computerName',
        'kernelVersion': 'kernelVersion',
        'systemGUID': null,
      };

      test('fromMap should return $MacOsDeviceInfo with correct values', () {
        final macosDeviceInfo = MacOsDeviceInfo.fromMap(macosDeviceInfoMap);

        expect(macosDeviceInfo.arch, 'arch');
        expect(macosDeviceInfo.model, 'model');
        expect(macosDeviceInfo.activeCPUs, 4);
        expect(macosDeviceInfo.memorySize, 16);
        expect(macosDeviceInfo.cpuFrequency, 2);
        expect(macosDeviceInfo.hostName, 'hostName');
        expect(macosDeviceInfo.osRelease, 'osRelease');
        expect(macosDeviceInfo.systemGUID, isNull);
      });
    });

    group('fromMap', () {
      const macosDeviceInfoMap = <String, dynamic>{
        'arch': 'arch',
        'model': 'model',
        'activeCPUs': 4,
        'memorySize': 16,
        'cpuFrequency': 2,
        'hostName': 'hostName',
        'osRelease': 'osRelease',
        'computerName': 'computerName',
        'kernelVersion': 'kernelVersion',
        'systemGUID': 'systemGUID',
      };

      test('fromMap should return $MacOsDeviceInfo with correct values', () {
        final macosDeviceInfo = MacOsDeviceInfo.fromMap(macosDeviceInfoMap);

        expect(macosDeviceInfo.arch, 'arch');
        expect(macosDeviceInfo.model, 'model');
        expect(macosDeviceInfo.activeCPUs, 4);
        expect(macosDeviceInfo.memorySize, 16);
        expect(macosDeviceInfo.cpuFrequency, 2);
        expect(macosDeviceInfo.hostName, 'hostName');
        expect(macosDeviceInfo.osRelease, 'osRelease');
        expect(macosDeviceInfo.systemGUID, 'systemGUID');
      });
    });
  });
}
