import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:nm/nm.dart';

// Used internally
// ignore_for_file: public_member_api_docs

@visibleForTesting
typedef NetworkManagerClientFactory = NetworkManagerClient Function();

/// The Linux implementation of ConnectivityPlatform.
class ConnectivityPlusLinuxPlugin extends ConnectivityPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    ConnectivityPlatform.instance = ConnectivityPlusLinuxPlugin();
  }

  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    final client = createClient();
    await client.connect();
    final connectivity = _getConnectivity(client);
    await client.close();
    return connectivity;
  }

  NetworkManagerClient? _client;
  StreamController<ConnectivityResult>? _controller;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    _controller ??= StreamController<ConnectivityResult>.broadcast(
      onListen: _startListenConnectivity,
      onCancel: _stopListenConnectivity,
    );
    return _controller!.stream;
  }

  ConnectivityResult _getConnectivity(NetworkManagerClient client) {
    if (client.connectivity == NetworkManagerConnectivityState.none) {
      return ConnectivityResult.none;
    }
    if (client.primaryConnectionType.contains('wireless')) {
      return ConnectivityResult.wifi;
    }
    if (client.primaryConnectionType.contains('ethernet')) {
      return ConnectivityResult.ethernet;
    }
    if (client.primaryConnectionType.contains('vpn')) {
      return ConnectivityResult.vpn;
    }
    if (client.primaryConnectionType.contains('bluetooth')) {
      return ConnectivityResult.bluetooth;
    }
    if (client.primaryConnectionType.contains('mobile')) {
      return ConnectivityResult.mobile;
    }
    return ConnectivityResult.other;
  }

  Future<void> _startListenConnectivity() async {
    _client ??= createClient();
    await _client!.connect();
    _addConnectivity(_client!);
    _client!.propertiesChanged.listen((properties) {
      if (properties.contains('Connectivity')) {
        _addConnectivity(_client!);
      }
    });
  }

  void _addConnectivity(NetworkManagerClient client) {
    _controller!.add(_getConnectivity(client));
  }

  Future<void> _stopListenConnectivity() async {
    await _client?.close();
    _client = null;
  }

  @visibleForTesting
  // ignore: prefer_function_declarations_over_variables
  NetworkManagerClientFactory createClient = () => NetworkManagerClient();
}
