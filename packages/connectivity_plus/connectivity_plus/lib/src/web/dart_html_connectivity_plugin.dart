import 'dart:async';
// Used in web: 0.3.0, deprecated later.
// Remove when increasing min web version.
// ignore: deprecated_member_use
import 'package:web/helpers.dart';
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
      const EventStreamProvider<Event>('online').forTarget(window).listen((_) {
        _connectivityResult!.add(ConnectivityResult.wifi);
      });
      const EventStreamProvider<Event>('offline').forTarget(window).listen((_) {
        _connectivityResult!.add(ConnectivityResult.none);
      });
    }
    return _connectivityResult!.stream;
  }
}
