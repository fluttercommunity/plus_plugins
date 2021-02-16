// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import 'src/utils.dart';

/// An implementation of [ConnectivityPlatform] that uses method channels.
class MethodChannelConnectivity extends ConnectivityPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  MethodChannel methodChannel =
      MethodChannel('dev.fluttercommunity.plus/connectivity');

  /// The event channel used to receive ConnectivityResult changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel =
      EventChannel('dev.fluttercommunity.plus/connectivity_status');

  Stream<ConnectivityResult> _onConnectivityChanged;

  /// Fires whenever the connectivity state changes.
  @override
  Stream<ConnectivityResult> get onConnectivityChanged {
    _onConnectivityChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic result) => result.toString())
        .map(parseConnectivityResult);
    return _onConnectivityChanged;
  }

  @override
  Future<ConnectivityResult> checkConnectivity() {
    return methodChannel
        .invokeMethod<String>('check')
        .then(parseConnectivityResult);
  }
}
