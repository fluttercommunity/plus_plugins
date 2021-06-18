import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// A stub implementation of the NetworkInfoPlatform interface for Web.
class NetworkInfoPlusPlugin extends NetworkInfoPlatform {
  /// Factory method that initializes the network info plugin platform with
  /// an instance of the plugin for the web.
  static void registerWith(Registrar registrar) {
    NetworkInfoPlatform.instance = NetworkInfoPlusPlugin();
  }

  /// Obtains the wifi name (SSID) of the connected network
  @override
  Future<String?> getWifiName() {
    throw UnsupportedError('getWifiName() is not supported on Web.');
  }

  /// Obtains the wifi BSSID of the connected network.
  @override
  Future<String?> getWifiBSSID() {
    throw UnsupportedError('getWifiBSSID() is not supported on Web.');
  }

  /// Obtains the IP address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    throw UnsupportedError('getWifiIP() is not supported on Web.');
  }
}
