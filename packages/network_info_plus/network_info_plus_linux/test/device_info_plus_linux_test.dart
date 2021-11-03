import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus_linux/src/network_info.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

void main() {
  test('registered instance', () {
    NetworkInfoLinux.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoLinux>());
  });
}
