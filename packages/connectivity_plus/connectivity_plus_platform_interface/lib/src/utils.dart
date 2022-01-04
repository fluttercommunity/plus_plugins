import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

/// Convert a String to a ConnectivityResult value.
ConnectivityResult parseConnectivityResult(String state) {
  switch (state) {
    case 'bluetooth':
      return ConnectivityResult.bluetooth;
    case 'wifi':
      return ConnectivityResult.wifi;
    case 'ethernet':
      return ConnectivityResult.ethernet;
    case 'mobile':
      return ConnectivityResult.mobile;
    case 'none':
    default:
      return ConnectivityResult.none;
  }
}
