// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mockito/mockito.dart';

const String kWifiNameResult = '1337wifi';
const String kWifiBSSIDResult = 'c0:ff:33:c0:d3:55';
const String kWifiIpAddressResult = '127.0.0.1';
const LocationAuthorizationStatus kRequestLocationResult =
    LocationAuthorizationStatus.authorizedAlways;
const LocationAuthorizationStatus kGetLocationResult =
    LocationAuthorizationStatus.authorizedAlways;

void main() {
  group('NetworkInfo', () {
    NetworkInfo networkInfo;
    MockNetworkInfoPlatform fakePlatform;
    setUp(() async {
      fakePlatform = MockNetworkInfoPlatform();
      NetworkInfoPlatform.instance = fakePlatform;
      networkInfo = NetworkInfo();
    });

    test('getWifiName', () async {
      final result = await networkInfo.getWifiName();
      expect(result, kWifiNameResult);
    });

    test('getWifiBSSID', () async {
      final result = await networkInfo.getWifiBSSID();
      expect(result, kWifiBSSIDResult);
    });

    test('getWifiIP', () async {
      final result = await networkInfo.getWifiIP();
      expect(result, kWifiIpAddressResult);
    });

    test('requestLocationServiceAuthorization', () async {
      final result = await networkInfo.requestLocationServiceAuthorization();
      expect(result, kRequestLocationResult);
    });

    test('getLocationServiceAuthorization', () async {
      final result = await networkInfo.getLocationServiceAuthorization();
      expect(result, kRequestLocationResult);
    });
  });
}

class MockNetworkInfoPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements NetworkInfoPlatform {
  @override
  Future<String> getWifiName() async {
    return kWifiNameResult;
  }

  @override
  Future<String> getWifiBSSID() async {
    return kWifiBSSIDResult;
  }

  @override
  Future<String> getWifiIP() async {
    return kWifiIpAddressResult;
  }

  @override
  Future<LocationAuthorizationStatus> requestLocationServiceAuthorization({
    bool requestAlwaysLocationUsage = false,
  }) async {
    return kRequestLocationResult;
  }

  @override
  Future<LocationAuthorizationStatus> getLocationServiceAuthorization() async {
    return kGetLocationResult;
  }
}
