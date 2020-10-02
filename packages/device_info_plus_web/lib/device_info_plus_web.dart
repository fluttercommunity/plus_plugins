import 'dart:async';
import 'dart:html' as html show window, Navigator;

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// The web implementation of the BatteryPlusPlatform of the BatteryPlus plugin.
class DeviceInfoPlugin extends DeviceInfoPlatform {
  DeviceInfoPlugin(navigator) : _navigator = navigator;

  final html.Navigator _navigator;

  /// Factory method that initializes the DeviceInfoPlus plugin platform
  /// with an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    DeviceInfoPlatform.instance = DeviceInfoPlugin(html.window.navigator);
  }

  @override
  Future<WebBrowserInfo> webBrowserInfo() {
    return Future<WebBrowserInfo>.value(
      WebBrowserInfo.fromMap(
        {
          'appCodeName': _navigator.appCodeName,
          'appName': _navigator.appName,
          'appVersion': _navigator.appVersion,
          'deviceMemory': _navigator.deviceMemory,
          'language': _navigator.language,
          'languages': _navigator.languages,
          'platform': _navigator.platform,
          'product': _navigator.product,
          'productSub': _navigator.productSub,
          'userAgent': _navigator.userAgent,
          'vendor': _navigator.vendor,
          'vendorSub': _navigator.vendorSub,
          'hardwareConcurrency': _navigator.hardwareConcurrency,
          'maxTouchPoints': _navigator.maxTouchPoints,
        },
      ),
    );
  }
}
