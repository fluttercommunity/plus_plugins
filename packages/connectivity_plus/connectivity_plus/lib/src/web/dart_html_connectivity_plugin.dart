import 'dart:async';
// import 'dart:js';
// import 'dart:html' as html show window;
import 'package:web/web.dart';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

import '../connectivity_plus_web.dart';

/// The web implementation of the ConnectivityPlatform of the Connectivity plugin.
class DartHtmlConnectivityPlugin extends ConnectivityPlusWebPlugin {
  /// Checks the connection status of the device.
  @override
  Future<ConnectivityResult> checkConnectivity() async {
    return (window.navigator.onLine)
        ? ConnectivityResult.wifi
        : ConnectivityResult.none;
  }

  StreamController<ConnectivityResult>? _connectivityResult;

  /// Returns a Stream of ConnectivityResults changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    if (_connectivityResult == null) {
      _connectivityResult = StreamController<ConnectivityResult>.broadcast();
      // Fallback to dart:html window.onOnline / window.onOffline
      window.ononline.listen((event) {
        _connectivityResult!.add(ConnectivityResult.wifi);
      });
      window.onoffline.listen((event) {
        _connectivityResult!.add(ConnectivityResult.none);
      });
    }
    return _connectivityResult!.stream;
  }
}
