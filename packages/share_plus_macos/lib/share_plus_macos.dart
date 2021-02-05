
import 'dart:async';

import 'package:flutter/services.dart';

class SharePlusMacos {
  static const MethodChannel _channel =
      const MethodChannel('share_plus_macos');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
