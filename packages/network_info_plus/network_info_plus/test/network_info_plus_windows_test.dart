@TestOn('windows')
library device_info_plus_windows_test;

import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusWindowsPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusWindowsPlugin>());
  });

  test('Test BSSID', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    plugin.init();
    final bssID = await plugin.getWifiBSSID();
    expect(bssID, equals('00:00'));
    plugin.closeHandle();
  });

  test('Wifi name', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    plugin.init();
    final wifiName = await plugin.getWifiName();
    expect(wifiName, equals('Sneath'));
    plugin.closeHandle();
  });
}
