import 'dart:async';

import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:meta/meta.dart';

import 'network_manager.dart';

// Used internally
// ignore_for_file: public_member_api_docs

typedef _DeviceGetter = Future<String?> Function(NMDevice device);
typedef _ConnectionGetter = Future<String?> Function(NMConnection connection);

@visibleForTesting
typedef NetworkManagerFactory = NetworkManager Function();

/// The Linux implementation of NetworkInfoPlatform.
class NetworkInfoLinux extends NetworkInfoPlatform {
  /// Obtains the wifi name (SSID) of the connected network
  @override
  Future<String?> getWifiName() {
    return _getConnectionValue((connection) => connection.getId());
  }

  /// Obtains the IP address of the connected wifi network
  @override
  Future<String?> getWifiIP() {
    return _getDeviceValue((device) => device.getIp4());
  }

  /// Obtains the wifi BSSID of the connected network.
  @override
  Future<String?> getWifiBSSID() {
    return _getDeviceValue((device) {
      return device
          .asWirelessDevice()
          .then((wireless) => wireless.getHwAddress());
    });
  }

  Future<String?> _getDeviceValue(_DeviceGetter getter) {
    return _getConnectionValue((connection) {
      return connection.createDevice().then((device) {
        return getter(device);
      });
    });
  }

  Future<String?> _getConnectionValue(_ConnectionGetter getter) {
    return _ref().createConnection().then((connection) {
      return getter(connection);
    }).whenComplete(_deref);
  }

  int _refCount = 0;
  NetworkManager? _manager;

  NetworkManager _ref() {
    _manager ??= createManager();
    ++_refCount;
    return _manager!;
  }

  void _deref() {
    // schedules an asynchronous disposal when the last reference is removed
    if (--_refCount == 0) {
      scheduleMicrotask(() {
        if (_refCount == 0) {
          _manager!.dispose();
          _manager = null;
        }
      });
    }
  }

  @visibleForTesting
  NetworkManagerFactory createManager = () => NetworkManager.system();
}
