import 'dart:async';
import 'dart:html' as html show window, NetworkInformation;
import 'dart:js_util';

import 'package:connectivity_plus/src/web/utils/connectivity_result.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/foundation.dart';
import 'package:js/js.dart';

import '../connectivity_plus_web.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class NetworkInformationApiConnectivityPlugin
    extends ConnectivityPlusWebPlugin {
  final html.NetworkInformation _networkInformation;

  /// A check to determine if this version of the plugin can be used.
  static bool isSupported() => html.window.navigator.connection != null;

  /// The constructor of the plugin.
  NetworkInformationApiConnectivityPlugin()
      : this.withConnection(html.window.navigator.connection!);

  /// Creates the plugin, with an override of the NetworkInformation object.
  @visibleForTesting
  NetworkInformationApiConnectivityPlugin.withConnection(
      html.NetworkInformation connection)
      : _networkInformation = connection;

  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return networkInformationToConnectivityResult(_networkInformation);
  }

  StreamController<ConnectivityResult>? _connectivityResultStreamController;
  late Stream<ConnectivityResult> _connectivityResultStream;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    // use fallback implementation if [_connectionSupported] is not availible
    if (_connectionSupported == null) {
      return _webPseudoStream();
    }
    if (_connectivityResultStreamController == null) {
      _connectivityResultStreamController =
          StreamController<ConnectivityResult>();
      setProperty(_networkInformation, 'onchange', allowInterop((_) {
        _connectivityResultStreamController!
            .add(networkInformationToConnectivityResult(_networkInformation));
      }));
      // ignore: todo
      // TODO: Implement the above with _networkInformation.onChange:
      // _networkInformation.onChange.listen((_) {
      //   _connectivityResult
      //       .add(networkInformationToConnectivityResult(_networkInformation));
      // });
      // Once we can detect when to *cancel* a subscription to the _networkInformation
      // onChange Stream upon hot restart.
      // https://github.com/dart-lang/sdk/issues/42679
      _connectivityResultStream =
          _connectivityResultStreamController!.stream.asBroadcastStream();
    }
    return _connectivityResultStream;
  }

  /// stores the last fallback network state
  ConnectivityResult? _lastFallbackState;

  /// periodically checks the current network state
  Stream<ConnectivityResult> _webPseudoStream() {
    final StreamController<ConnectivityResult> webStream =
        StreamController.broadcast();
    Timer.periodic(
      const Duration(milliseconds: 250),
      (timer) async {
        final result = await checkConnectivity();
        if (result != _lastFallbackState) {
          webStream.add(result);
        }
      },
    );
    return webStream.stream;
  }
}

/// accesses the JS-native `navigator.connection`
///
/// ensures `navigator.connection.onchange` is availible
@JS("navigator.connection")
external get _connectionSupported;
