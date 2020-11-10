
import 'dart:async';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter/services.dart';

class DeviceInfoPlusMacos extends DeviceInfoPlatform{
  static const MethodChannel _channel =
      const MethodChannel('device_info_plus_macos');

  static Future<String> get platformVersion async {
    final Map<dynamic , dynamic> version = await _channel.invokeMethod('getPlatformVersion');
    print(version);
    return version['computerName'];
  }
}
