import 'dart:async';

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
      completion(equals([ConnectivityResult.bluetooth])),
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
      completion(equals([ConnectivityResult.ethernet])),
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
      completion(equals([ConnectivityResult.wifi])),
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
      completion(equals([ConnectivityResult.vpn])),
    );
  });

  test('wireless+vpn', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('wireless,vpn');
      return client;
    };
    expect(
      linux.checkConnectivity(),
      completion(equals([ConnectivityResult.wifi, ConnectivityResult.vpn])),
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
    expect(linux.checkConnectivity(),
        completion(equals([ConnectivityResult.none])));
  });

  test('checkConnectivity closes the client after an error', () async {
    final linux = ConnectivityPlusLinuxPlugin();
    final client = MockNetworkManagerClient();
    when(client.connect()).thenAnswer((_) async {});
    when(client.close()).thenAnswer((_) async {});
    when(client.connectivity).thenThrow(StateError('Failed to read state'));
    linux.createClient = () => client;

    await expectLater(linux.checkConnectivity(), throwsStateError);

    verify(client.close()).called(1);
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
    expect(
        linux.onConnectivityChanged,
        emitsInOrder([
          [ConnectivityResult.wifi],
          [ConnectivityResult.none]
        ]));
  });

  test('canceling the last listener cancels the property subscription',
      () async {
    final linux = ConnectivityPlusLinuxPlugin();
    final client = MockNetworkManagerClient();
    final propertiesChanged = StreamController<List<String>>.broadcast();
    final clientClosed = Completer<void>();
    addTearDown(propertiesChanged.close);
    when(client.connect()).thenAnswer((_) async {});
    when(client.close()).thenAnswer((_) async {
      clientClosed.complete();
    });
    when(client.connectivity).thenReturn(NetworkManagerConnectivityState.full);
    when(client.primaryConnectionType).thenReturn('wireless');
    when(client.propertiesChanged).thenAnswer((_) => propertiesChanged.stream);
    linux.createClient = () => client;

    final initialEvent = Completer<void>();
    final subscription = linux.onConnectivityChanged.listen((_) {
      initialEvent.complete();
    });
    await initialEvent.future;
    expect(propertiesChanged.hasListener, isTrue);

    await subscription.cancel();
    await clientClosed.future;

    expect(propertiesChanged.hasListener, isFalse);
    verify(client.close()).called(1);
  });

  test('canceling while connecting does not reuse the closing client',
      () async {
    final linux = ConnectivityPlusLinuxPlugin();
    final clients = <MockNetworkManagerClient>[];
    final connectCompleters = <Completer<void>>[];
    final closeCompleters = <Completer<void>>[];
    final closeCalledCompleters = <Completer<void>>[];
    linux.createClient = () {
      final client = MockNetworkManagerClient();
      final connectCompleter = Completer<void>();
      final closeCompleter = Completer<void>();
      final closeCalledCompleter = Completer<void>();
      when(client.connect()).thenAnswer((_) => connectCompleter.future);
      when(client.close()).thenAnswer((_) {
        closeCalledCompleter.complete();
        return closeCompleter.future;
      });
      when(client.connectivity)
          .thenReturn(NetworkManagerConnectivityState.full);
      when(client.primaryConnectionType).thenReturn('wireless');
      when(client.propertiesChanged)
          .thenAnswer((_) => Stream<List<String>>.empty());
      clients.add(client);
      connectCompleters.add(connectCompleter);
      closeCompleters.add(closeCompleter);
      closeCalledCompleters.add(closeCalledCompleter);
      return client;
    };

    final errors = <Object>[];
    await runZonedGuarded(
      () async {
        final firstSubscription = linux.onConnectivityChanged.listen((_) {});
        await firstSubscription.cancel();

        final secondSubscription = linux.onConnectivityChanged.listen((_) {});

        closeCompleters.first.complete();

        for (final completer in connectCompleters) {
          completer.complete();
        }
        await Future.wait(
          connectCompleters.map((completer) => completer.future),
        );

        await secondSubscription.cancel();
        for (final completer in closeCompleters) {
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
        await Future.wait(
          closeCalledCompleters.map((completer) => completer.future),
        );
      },
      (error, stackTrace) {
        errors.add(error);
      },
    );

    expect(errors, isEmpty);
    expect(clients, hasLength(2));
    verify(clients.first.close()).called(1);
    verify(clients.last.close()).called(1);
  });
}
