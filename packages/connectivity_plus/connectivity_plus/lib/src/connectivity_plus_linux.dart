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
    final client = createClient();
    try {
      await client.connect();
      return _getConnectivity(client);
    } finally {
      await client.close();
    }
  }

  _NetworkManagerClientSession? _clientSession;
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
    final session =
        _clientSession ??= _NetworkManagerClientSession(createClient());
    try {
      await session.connected;

      if (!identical(_clientSession, session)) {
        return;
      }

      final client = session.client;
      _addConnectivity(client);
      session.propertiesChangedSubscription =
          client.propertiesChanged.listen((properties) {
        if (identical(_clientSession, session) &&
            properties.contains('Connectivity')) {
          _addConnectivity(client);
        }
      });
    } catch (_) {
      if (identical(_clientSession, session)) {
        _clientSession = null;
      }
      await session.close();
      rethrow;
    }
  }

  void _addConnectivity(NetworkManagerClient client) {
    _controller!.add(_getConnectivity(client));
  }

  Future<void> _stopListenConnectivity() async {
    final session = _clientSession;
    _clientSession = null;
    await session?.close();
  }

  @visibleForTesting
  // ignore: prefer_function_declarations_over_variables
  NetworkManagerClientFactory createClient = () => NetworkManagerClient();
}

class _NetworkManagerClientSession {
  _NetworkManagerClientSession(this.client) : connected = client.connect();

  final NetworkManagerClient client;
  final Future<void> connected;
  StreamSubscription<List<String>>? propertiesChangedSubscription;

  Future<void>? _closeFuture;

  Future<void> close() => _closeFuture ??= _close();

  Future<void> _close() async {
    try {
      await connected;
    } catch (_) {
      // Connection errors are reported by the listener setup.
    }
    try {
      await propertiesChangedSubscription?.cancel();
    } finally {
      await client.close();
    }
  }
}
