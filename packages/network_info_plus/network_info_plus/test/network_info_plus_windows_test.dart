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
    final bssID = await plugin.getWifiBSSID();
    expect(bssID, equals('00:00:00:00:00:00'));
  });

  test('Wifi name', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final wifiName = await plugin.getWifiName();
    expect(wifiName, isNotEmpty);
  });

  test('IP Address', () async {
    final plugin = NetworkInfoPlusWindowsPlugin();
    final ipAddress = await plugin.getWifiIP();
    expect(
        ipAddress,
        matches(
            r'^(?=\d+\.\d+\.\d+\.\d+$)(?:(?:25[0-5]|2[0-4][0-9]|1[0-9]{2}|[1-9][0-9]|[0-9])\.?){4}$'));
  });
}
