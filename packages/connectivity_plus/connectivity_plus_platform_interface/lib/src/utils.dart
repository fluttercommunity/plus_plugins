import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

/// Convert a comma-separated String to a list of ConnectivityResult values.
List<ConnectivityResult> parseConnectivityResults(List<String> states) {
  return states.map((state) {
    switch (state.trim()) {
      case 'bluetooth':
        return ConnectivityResult.bluetooth;
      case 'wifi':
        return ConnectivityResult.wifi;
      case 'ethernet':
        return ConnectivityResult.ethernet;
      case 'mobile':
        return ConnectivityResult.mobile;
      case 'vpn':
        return ConnectivityResult.vpn;
      case 'other':
        return ConnectivityResult.other;
      default:
        return ConnectivityResult.none;
    }
  }).toList();
}
