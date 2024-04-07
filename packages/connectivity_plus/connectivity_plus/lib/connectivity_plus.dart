// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

// Export enums from the platform_interface so plugin users can use them directly.
export 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart'
    show ConnectivityResult;

export 'src/connectivity_plus_linux.dart'
    if (dart.library.js_interop) 'src/connectivity_plus_web.dart';

/// Discover network connectivity configurations: Distinguish between WI-FI and cellular, check WI-FI status and more.
class Connectivity {
  /// Constructs a singleton instance of [Connectivity].
  ///
  /// [Connectivity] is designed to work as a singleton.
  // When a second instance is created, the first instance will not be able to listen to the
  // EventChannel because it is overridden. Forcing the class to be a singleton class can prevent
  // misuse of creating a second instance from a programmer.
  factory Connectivity() {
    _singleton ??= Connectivity._();
    return _singleton!;
  }

  Connectivity._();

  static Connectivity? _singleton;

  static ConnectivityPlatform get _platform {
    return ConnectivityPlatform.instance;
  }

  /// Exposes connectivity update events from the platform.
  ///
  /// On iOS, the connectivity status might not update when WiFi
  /// status changes, this is a known issue that only affects simulators.
  /// For details see https://github.com/fluttercommunity/plus_plugins/issues/479.
  ///
  /// On Android, the Stream may emit new values even when
  /// the [ConnectivityResult] list remains the same.
  ///
  /// The emitted list is never empty. In case of no connectivity, the list contains
  /// a single element of [ConnectivityResult.none]. Note also that this is the only
  /// case where [ConnectivityResult.none] is present.
  ///
  /// This method doesn't filter events, nor it ensures distinct values.
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _platform.onConnectivityChanged;
  }

  /// Checks the connection status of the device.
  ///
  /// Do not use the result of this function to decide whether you can reliably
  /// make a network request, it only gives you the radio status. Instead, listen
  /// for connectivity changes via [onConnectivityChanged] stream.
  ///
  /// The returned list is never empty. In case of no connectivity, the list contains
  /// a single element of [ConnectivityResult.none]. Note also that this is the only
  /// case where [ConnectivityResult.none] is present.
  Future<List<ConnectivityResult>> checkConnectivity() {
    return _platform.checkConnectivity();
  }
}
