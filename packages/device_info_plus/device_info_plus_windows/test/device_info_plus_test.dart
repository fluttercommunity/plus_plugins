import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:device_info_plus_windows/src/device_info_plus_windows_real.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('registered instance', () {
    DeviceInfoWindows.registerWith();
    expect(DeviceInfoPlatform.instance, isA<DeviceInfoWindows>());
  });
}
