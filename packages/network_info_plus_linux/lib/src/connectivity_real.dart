import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:meta/meta.dart';

import 'network_manager.dart';

// Used internally
// ignore_for_file: public_member_api_docs

typedef _DeviceGetter = Future<String> Function(NMDevice device);
typedef _ConnectionGetter = Future<String> Function(NMConnection connection);

@visibleForTesting
typedef NetworkManagerFactory = NetworkManager Function();

/// The Linux implementation of ConnectivityPlatform.
class ConnectivityLinux extends ConnectivityPlatform {
  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() {
    return _getConnectivity(_ref()).whenComplete(_deref);
  }

  /// Obtains the wifi name (SSID) of the connected network
  @override
  Future<String> getWifiName() {
    return _getConnectionValue((connection) => connection.getId());
  }

  /// Obtains the IP address of the connected wifi network
  @override
  Future<String> getWifiIP() {
    return _getDeviceValue((device) => device.getIp4());
  }

  /// Obtains the wifi BSSID of the connected network.
  @override
  Future<String> getWifiBSSID() {
    return _getDeviceValue((device) {
      return device
          .asWirelessDevice()
          .then((wireless) => wireless?.getHwAddress());
    });
  }

  Future<String> _getDeviceValue(_DeviceGetter getter) {
    return _getConnectionValue((connection) {
      return connection.createDevice().then((device) {
        return device != null ? getter(device) : null;
      });
    });
  }

  Future<String> _getConnectionValue(_ConnectionGetter getter) {
    return _ref().createConnection().then((connection) {
      return connection != null ? getter(connection) : null;
    }).whenComplete(_deref);
  }

  int _refCount = 0;
  NetworkManager _manager;
  StreamController<ConnectivityResult> _controller;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    _controller ??= StreamController<ConnectivityResult>.broadcast(
      onListen: _startListenConnectivity,
      onCancel: _deref,
    );
    return _controller.stream;
  }

  Future<ConnectivityResult> _getConnectivity(NetworkManager manager) {
    return manager.getType().then((value) => value.toConnectivityResult());
  }

  void _startListenConnectivity() {
    final manager = _ref();
    manager.getType().then((type) => _addConnectivity(type));
    manager.subscribeTypeChanged().listen((type) {
      _addConnectivity(type);
    });
  }

  void _addConnectivity(String type) {
    _controller.add(type.toConnectivityResult());
  }

  NetworkManager _ref() {
    _manager ??= createManager();
    ++_refCount;
    return _manager;
  }

  void _deref() {
    // schedules an asynchronous disposal when the last reference is removed
    if (--_refCount == 0) {
      scheduleMicrotask(() {
        if (_refCount == 0) {
          _manager.dispose();
          _manager = null;
        }
      });
    }
  }

  @visibleForTesting
  NetworkManagerFactory createManager = () => NetworkManager.system();
}

extension _NMConnectivityType on String {
  ConnectivityResult toConnectivityResult() {
    if (isEmpty) {
      return ConnectivityResult.none;
    }
    if (contains('wireless')) {
      return ConnectivityResult.wifi;
    }
    // ### TODO: ethernet
    //if (contains('ethernet')) {
    //  return ConnectivityResult.ethernet;
    //}
    // gsm, cdma, bluetooth, ...
    return ConnectivityResult.mobile;
  }
}
