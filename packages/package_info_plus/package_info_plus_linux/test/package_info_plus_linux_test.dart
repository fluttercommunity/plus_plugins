import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus_linux/src/package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

void main() {
  test('registered instance', () {
    PackageInfoLinux.registerWith();
    expect(PackageInfoPlatform.instance, isA<PackageInfoLinux>());
  });
}
