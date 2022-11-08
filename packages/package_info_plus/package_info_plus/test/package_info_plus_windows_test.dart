import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/src/package_info_plus_windows.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

void main() {
  test('registered instance', () {
    PackageInfoPlusWindowsPlugin.registerWith();
    expect(PackageInfoPlatform.instance, isA<PackageInfoPlusWindowsPlugin>());
  });
}
