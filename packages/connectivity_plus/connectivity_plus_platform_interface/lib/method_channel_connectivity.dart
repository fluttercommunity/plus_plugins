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
  MethodChannel methodChannel = const MethodChannel(
    'dev.fluttercommunity.plus/connectivity',
  );

  /// The event channel used to receive ConnectivityResult changes from the native platform.
  @visibleForTesting
  EventChannel eventChannel = const EventChannel(
    'dev.fluttercommunity.plus/connectivity_status',
  );

  Stream<List<ConnectivityResult>>? _onConnectivityChanged;

  /// Fires whenever the connectivity state changes.
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    _onConnectivityChanged ??= eventChannel
        .receiveBroadcastStream()
        .map((dynamic result) => List<String>.from(result))
        .map(parseConnectivityResults);
    return _onConnectivityChanged!;
  }

  @override
  Future<List<ConnectivityResult>> checkConnectivity() {
    return methodChannel
        .invokeListMethod<String>('check')
        .then((value) => parseConnectivityResults(value ?? []));
  }
}
