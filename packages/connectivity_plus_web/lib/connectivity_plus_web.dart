import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'src/network_information_api_connectivity_plugin.dart';
import 'src/dart_html_connectivity_plugin.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class ConnectivityPlusPlugin extends ConnectivityPlatform {
  /// Factory method that initializes the connectivity plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    if (NetworkInformationApiConnectivityPlugin.isSupported()) {
      ConnectivityPlatform.instance = NetworkInformationApiConnectivityPlugin();
    } else {
      ConnectivityPlatform.instance = DartHtmlConnectivityPlugin();
    }
  }
}
