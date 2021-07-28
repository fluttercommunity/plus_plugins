import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:nm/nm.dart';

// Used internally
// ignore_for_file: public_member_api_docs

@visibleForTesting
typedef NetworkManagerClientFactory = NetworkManagerClient Function();

/// The Linux implementation of ConnectivityPlatform.
class ConnectivityLinux extends ConnectivityPlatform {
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
    if (client.connectivity != NetworkManagerConnectivityState.full) {
      return ConnectivityResult.none;
    }
    // ### TODO: ConnectivityResult.ethernet
    if (client.primaryConnectionType.contains('wireless') ||
        client.primaryConnectionType.contains('ethernet')) {
      return ConnectivityResult.wifi;
    }
    return ConnectivityResult.mobile;
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
  NetworkManagerClientFactory createClient = () => NetworkManagerClient();
}
