import 'package:connectivity_plus/src/connectivity_plus_linux.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nm/nm.dart';

import 'connectivity_plus_linux_test.mocks.dart';

@GenerateMocks([NetworkManagerClient])
void main() {
  test('registered instance', () {
    ConnectivityPlusLinuxPlugin.registerWith();
    expect(ConnectivityPlatform.instance, isA<ConnectivityPlusLinuxPlugin>());
  });

  test('bluetooth', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('bluetooth');
      return client;
    };
    expect(
      linux.checkConnectivity(),
      completion(equals(ConnectivityResult.bluetooth)),
    );
  });

  test('ethernet', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('ethernet');
      return client;
    };
    expect(
      linux.checkConnectivity(),
      completion(equals(ConnectivityResult.ethernet)),
    );
  });

  test('wireless', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('wireless');
      return client;
    };
    expect(
      linux.checkConnectivity(),
      completion(equals(ConnectivityResult.wifi)),
    );
  });

  test('vpn', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('vpn');
      return client;
    };
    expect(
      linux.checkConnectivity(),
      completion(equals(ConnectivityResult.vpn)),
    );
  });

  test('no connectivity', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.none);
      return client;
    };
    expect(
        linux.checkConnectivity(), completion(equals(ConnectivityResult.none)));
  });

  test('connectivity changes', () {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('wireless');
      when(client.propertiesChanged).thenAnswer((_) {
        when(client.connectivity)
            .thenReturn(NetworkManagerConnectivityState.none);
        return Stream.value(['Connectivity']);
      });
      return client;
    };
    expect(linux.onConnectivityChanged,
        emitsInOrder([ConnectivityResult.wifi, ConnectivityResult.none]));
  });
}
