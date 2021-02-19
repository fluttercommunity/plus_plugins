//@dart=2.9

import 'package:connectivity_plus_linux/src/connectivity_real.dart';
import 'package:connectivity_plus_linux/src/network_manager.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  test('wireless', () async {
    final linux = ConnectivityLinux();
    linux.createManager = () {
      final manager = MockNetworkManager();
      when(manager.getType()).thenAnswer((_) => Future.value('wireless'));
      return manager;
    };
    expect(
        linux.checkConnectivity(), completion(equals(ConnectivityResult.wifi)));
  });

  test('no connectivity', () async {
    final linux = ConnectivityLinux();
    linux.createManager = () {
      final manager = MockNetworkManager();
      when(manager.getType()).thenAnswer((_) => Future.value(''));
      return manager;
    };
    expect(
        linux.checkConnectivity(), completion(equals(ConnectivityResult.none)));
  });

  test('connectivity changes', () {
    final linux = ConnectivityLinux();
    linux.createManager = () {
      final manager = MockNetworkManager();
      when(manager.getType()).thenAnswer((_) {
        return Future.value('wireless');
      });
      when(manager.subscribeTypeChanged()).thenAnswer((_) {
        return Stream.value('');
      });
      return manager;
    };
    expect(linux.onConnectivityChanged,
        emitsInOrder([ConnectivityResult.wifi, ConnectivityResult.none]));
  });
}

class MockNetworkManager extends Mock implements NetworkManager {}
