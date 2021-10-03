import 'dart:async';

import 'package:collection/collection.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:nm/nm.dart';

// Used internally
// ignore_for_file: public_member_api_docs

typedef _DeviceGetter = Future<String?> Function(NetworkManagerDevice? device);
typedef _ConnectionGetter = Future<String?> Function(
    NetworkManagerActiveConnection? connection);

@visibleForTesting
typedef NetworkManagerClientFactory = NetworkManagerClient Function();

/// The Linux implementation of NetworkInfoPlatform.
class NetworkInfoLinux extends NetworkInfoPlatform {
  /// Obtains the wifi name (SSID) of the connected network
  @override
  Future<String?> getWifiName() {
    return _getConnectionValue((connection) async => connection?.id);
  }

  /// Obtains the IP v4 address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    return _getConnectionValue(
      (connection) async => _getIpAddress(connection?.ip4Config?.addressData),
    );
  }

  /// Obtains the IP v6 address of the connected wifi network
  @override
  Future<String?> getWifiIPv6() {
    return _getConnectionValue(
      (connection) async => _getIpAddress(connection?.ip6Config?.addressData),
    );
  }

  /// Obtains the wifi BSSID of the connected network.
  @override
  Future<String?> getWifiBSSID() {
    return _getDeviceValue((device) async => device?.wireless?.permHwAddress);
  }

  /// Obtains the submask of the connected wifi network
  @override
  Future<String?> getWifiSubmask() {
    return _getConnectionValue(
      (connection) async => _getSubnetMask(connection?.ip4Config?.addressData),
    );
  }

  /// Obtains the gateway IP address of the connected wifi network
  @override
  Future<String?> getWifiGatewayIP() {
    return _getConnectionValue(
      (connection) async => connection?.ip4Config?.gateway,
    );
  }

  /// Obtains the broadcast of the connected wifi network
  @override
  Future<String?> getWifiBroadcast() {
    return _getConnectionValue(
      (connection) async => _getBroadcast(connection?.ip4Config?.addressData),
    );
  }

  Future<String?> _getDeviceValue(_DeviceGetter getter) {
    return _getConnectionValue((connection) {
      final device = connection?.devices
          .firstWhereOrNull((device) => device.wireless != null);
      return getter(device);
    });
  }

  Future<String?> _getConnectionValue(_ConnectionGetter getter) async {
    final client = createClient();
    await client.connect();
    final value = getter(client.primaryConnection);
    await client.close();
    return value;
  }

  String? _getIpAddress(List<Map<String, dynamic>>? data) {
    return data?.firstOrNull?['address'] as String;
  }

  String? _getSubnetMask(List<Map<String, dynamic>>? data) {
    final prefix = data?.firstOrNull?['prefix'] as int;
    final mask = 0xffffffff >> (32 - prefix);
    return mask.toIpString();
  }

  String? _getBroadcast(List<Map<String, dynamic>>? data) {
    final ip = _getIpAddress(data)?.toIpInt() ?? 0;
    final mask = _getSubnetMask(data)?.toIpInt() ?? 0;
    return (ip | (mask ^ 0xffffffff)).toIpString();
  }

  @visibleForTesting
  NetworkManagerClientFactory createClient = () => NetworkManagerClient();
}

extension _IpInt on int {
  int byteAt(int i) => (this >> (i * 8)) & 0xff;
  String toIpString() => '${byteAt(0)}.${byteAt(1)}.${byteAt(2)}.${byteAt(3)}';
}

extension _IpString on String {
  int toIpInt() {
    final parts = split('.');
    return parts.intAtOrZero(3) << 24 |
        parts.intAtOrZero(2) << 16 |
        parts.intAtOrZero(1) << 8 |
        parts.intAtOrZero(0);
  }
}

extension _IntOrZero on List<String> {
  int intAtOrZero(int i) => i < 0 || i >= length ? 0 : int.parse(this[i]);
}
