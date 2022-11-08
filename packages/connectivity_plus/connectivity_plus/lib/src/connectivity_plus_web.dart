import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'web/network_information_api_connectivity_plugin.dart';
import 'web/dart_html_connectivity_plugin.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class ConnectivityPlusWebPlugin extends ConnectivityPlatform {
  /// Factory method that initializes the connectivity plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    // Since the `NetworkInformationApi` is currently an experimental API and
    // does not provide a reliable way to check a connectivity change
    // from an onnline state to an offline state,
    // its implementation is disabled for now.
    // See also: https://developer.mozilla.org/en-US/docs/Web/API/Network_Information_API
    //
    // TODO: use `NetworkInformationApiConnectivityPlugin.isSupported()` when it becomes a stable DOM API.
    const isSupported = false;

    if (isSupported) {
      ConnectivityPlatform.instance = NetworkInformationApiConnectivityPlugin();
    } else {
      ConnectivityPlatform.instance = DartHtmlConnectivityPlugin();
    }
  }
}
