// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mockito/mockito.dart';

const List<ConnectivityResult> kCheckConnectivityResult = [
  ConnectivityResult.wifi
];

const List<ConnectivityResult> kCheckConnectivitySatelliteResult = [
  ConnectivityResult.mobile,
  ConnectivityResult.satellite,
];

void main() {
  group('Connectivity', () {
    late Connectivity connectivity;
    MockConnectivityPlatform fakePlatform;
    setUp(() async {
      fakePlatform = MockConnectivityPlatform();
      ConnectivityPlatform.instance = fakePlatform;
      connectivity = Connectivity();
    });

    test('checkConnectivity', () async {
      final result = await connectivity.checkConnectivity();
      expect(result, kCheckConnectivityResult);
    });

    test('checkConnectivity passes through satellite', () async {
      final satellitePlatform = MockSatelliteConnectivityPlatform();
      ConnectivityPlatform.instance = satellitePlatform;
      connectivity = Connectivity();
      final result = await connectivity.checkConnectivity();
      expect(
        result,
        containsAll(kCheckConnectivitySatelliteResult),
      );
    });
  });
}

class MockConnectivityPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return kCheckConnectivityResult;
  }
}

class MockSatelliteConnectivityPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async {
    return kCheckConnectivitySatelliteResult;
  }
}
