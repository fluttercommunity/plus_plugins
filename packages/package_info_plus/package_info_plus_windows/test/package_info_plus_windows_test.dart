import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:package_info_plus_windows/src/package_info_plus_windows.dart';

void main() {
  test('registered instance', () {
    PackageInfoWindows.registerWith();
    expect(PackageInfoPlatform.instance, isA<PackageInfoWindows>());
  });
}
