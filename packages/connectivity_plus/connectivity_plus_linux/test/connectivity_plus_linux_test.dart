import 'package:connectivity_plus_linux/src/connectivity.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nm/nm.dart';

import 'connectivity_plus_linux_test.mocks.dart';

@GenerateMocks([NetworkManagerClient])
void main() {
  test('registered instance', () {
    ConnectivityLinux.registerWith();
    expect(ConnectivityPlatform.instance, isA<ConnectivityLinux>());
  });
  test('wireless', () async {
    final linux = ConnectivityLinux();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('wireless');
      return client;
    };
    expect(
        linux.checkConnectivity(), completion(equals(ConnectivityResult.wifi)));
  });

  test('no connectivity', () async {
    final linux = ConnectivityLinux();
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
    final linux = ConnectivityLinux();
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
