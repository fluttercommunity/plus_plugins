import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusLinuxPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusLinuxPlugin>());
  });
}
