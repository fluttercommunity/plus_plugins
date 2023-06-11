import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

class DeviceProvider {
  static Device? getDevice() {
    if (kIsWeb) {
      return Web();
    } else {
      if (Platform.isAndroid) {
        return Android();
      } else if (Platform.isIOS) {
        return IOS();
      } else if (Platform.isLinux) {
        return Linux();
      } else if (Platform.isMacOS) {
        return MacOS();
      } else if (Platform.isWindows) {
        return Windows();
      } else {
        return null;
      }
    }
  }
}
