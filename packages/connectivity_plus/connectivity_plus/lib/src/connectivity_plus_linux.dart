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
  Future<List<ConnectivityResult>> checkConnectivity() async {
    try {
      final client = createClient();
      await client.connect();
      final connectivity = _getConnectivity(client);
      await client.close();
      return connectivity;
    } catch (e) {
      // NetworkManager may not be installed or running on this Linux system.
      // Rather than crashing, we gracefully degrade by treating this as
      // no connectivity. This ensures the plugin works on all Linux distributions
      // regardless of their network management infrastructure.
      return [ConnectivityResult.none];
    }
  }

  NetworkManagerClient? _client;
  StreamController<List<ConnectivityResult>>? _controller;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    _controller ??= StreamController<List<ConnectivityResult>>.broadcast(
      onListen: _startListenConnectivity,
      onCancel: _stopListenConnectivity,
    );
    return _controller!.stream;
  }

  List<ConnectivityResult> _getConnectivity(NetworkManagerClient client) {
    final List<ConnectivityResult> results = [];
    if (client.connectivity == NetworkManagerConnectivityState.none) {
      results.add(ConnectivityResult.none);
    } else {
      if (client.primaryConnectionType.contains('wireless')) {
        results.add(ConnectivityResult.wifi);
      }
      if (client.primaryConnectionType.contains('ethernet')) {
        results.add(ConnectivityResult.ethernet);
      }
      if (client.primaryConnectionType.contains('vpn')) {
        results.add(ConnectivityResult.vpn);
      }
      if (client.primaryConnectionType.contains('bluetooth')) {
        results.add(ConnectivityResult.bluetooth);
      }
      if (client.primaryConnectionType.contains('mobile')) {
        results.add(ConnectivityResult.mobile);
      }
      // Assuming 'other' is a catch-all for unspecified types
      if (results.isEmpty) {
        results.add(ConnectivityResult.other);
      }
    }
    return results;
  }

  Future<void> _startListenConnectivity() async {
    try {
      _client ??= createClient();
      await _client!.connect();
      _addConnectivity(_client!);
      _client!.propertiesChanged.listen((properties) {
        if (properties.contains('Connectivity')) {
          _addConnectivity(_client!);
        }
      });
    } catch (e) {
      // NetworkManager may not be installed or running on this Linux system.
      // We emit ConnectivityResult.none to the stream to indicate no connectivity
      // can be determined, rather than crashing the application.
      _controller?.add([ConnectivityResult.none]);
    }
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
