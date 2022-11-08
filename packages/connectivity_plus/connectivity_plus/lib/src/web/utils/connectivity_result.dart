import 'dart:html' as html show NetworkInformation;

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

/// Converts an incoming NetworkInformation object into the correct ConnectivityResult.
ConnectivityResult networkInformationToConnectivityResult(
  html.NetworkInformation info,
) {
  if (info.downlink == 0 && info.rtt == 0) {
    return ConnectivityResult.none;
  }
  if (info.type != null) {
    return _typeToConnectivityResult(info.type!);
  }
  if (info.effectiveType != null) {
    return _effectiveTypeToConnectivityResult(info.effectiveType!);
  }
  return ConnectivityResult.none;
}

ConnectivityResult _effectiveTypeToConnectivityResult(String effectiveType) {
  // Possible values:
  /*'2g'|'3g'|'4g'|'slow-2g'*/
  switch (effectiveType) {
    case 'slow-2g':
    case '2g':
    case '3g':
    case '4g':
      return ConnectivityResult.mobile;
    default:
      return ConnectivityResult.wifi;
  }
}

ConnectivityResult _typeToConnectivityResult(String type) {
  // Possible values:
  /*'bluetooth'|'cellular'|'ethernet'|'mixed'|'none'|'other'|'unknown'|'wifi'|'wimax'*/
  switch (type) {
    case 'none':
      return ConnectivityResult.none;
    case 'bluetooth':
      return ConnectivityResult.bluetooth;
    case 'cellular':
    case 'mixed':
    case 'other':
    case 'unknown':
      return ConnectivityResult.mobile;
    case 'ethernet':
      return ConnectivityResult.ethernet;
    default:
      return ConnectivityResult.wifi;
  }
}
