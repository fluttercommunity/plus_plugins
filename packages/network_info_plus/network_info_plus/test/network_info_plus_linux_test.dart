import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:nm/nm.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusLinuxPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusLinuxPlugin>());
  });

  group('IPv4 subnet mask and broadcast', () {
    // address, prefix, expected mask, expected broadcast
    const cases = [
      ('192.168.1.10', 24, '255.255.255.0', '192.168.1.255'),
      ('192.168.1.10', 22, '255.255.252.0', '192.168.3.255'),
      ('192.168.1.10', 25, '255.255.255.128', '192.168.1.127'),
      ('10.1.2.3', 8, '255.0.0.0', '10.255.255.255'),
      ('172.16.5.4', 12, '255.240.0.0', '172.31.255.255'),
      ('200.100.50.25', 20, '255.255.240.0', '200.100.63.255'),
      ('10.0.0.1', 30, '255.255.255.252', '10.0.0.3'),
      ('192.168.1.10', 32, '255.255.255.255', '192.168.1.10'),
      ('192.168.1.10', 0, '0.0.0.0', '255.255.255.255'),
    ];

    for (final (address, prefix, mask, broadcast) in cases) {
      test('$address/$prefix', () async {
        final plugin = NetworkInfoPlusLinuxPlugin()
          ..createClient = () => _FakeClient.withAddress(address, prefix);

        expect(await plugin.getWifiSubmask(), mask);
        expect(await plugin.getWifiBroadcast(), broadcast);
      });
    }
  });

  test('wifi IP and gateway are passed through', () async {
    final plugin = NetworkInfoPlusLinuxPlugin()
      ..createClient = () => _FakeClient.withAddress('192.168.1.10', 22);

    expect(await plugin.getWifiIP(), '192.168.1.10');
    expect(await plugin.getWifiGatewayIP(), '192.168.0.1');
  });

  group('missing IPv4 data returns null', () {
    final cases = <String, NetworkManagerActiveConnection? Function()>{
      'primaryConnection is null': () => null,
      'ip4Config is null': () => _FakeConnection(null),
      'addressData is empty': () => _FakeConnection(_FakeIp4Config([])),
    };

    for (final MapEntry(key: description, value: connection) in cases.entries) {
      test(description, () async {
        final plugin = NetworkInfoPlusLinuxPlugin()
          ..createClient = () => _FakeClient(connection());

        expect(await plugin.getWifiSubmask(), isNull);
        expect(await plugin.getWifiBroadcast(), isNull);
        expect(await plugin.getWifiIP(), isNull);
      });
    }
  });
}

class _FakeClient extends Fake implements NetworkManagerClient {
  _FakeClient(this.primaryConnection);

  _FakeClient.withAddress(String address, int prefix)
    : primaryConnection = _FakeConnection(
        _FakeIp4Config([
          {'address': address, 'prefix': prefix},
        ]),
      );

  @override
  final NetworkManagerActiveConnection? primaryConnection;

  @override
  Future<void> connect() async {}

  @override
  Future<void> close() async {}
}

class _FakeConnection extends Fake implements NetworkManagerActiveConnection {
  _FakeConnection(this.ip4Config);

  @override
  final NetworkManagerIP4Config? ip4Config;
}

class _FakeIp4Config extends Fake implements NetworkManagerIP4Config {
  _FakeIp4Config(this.addressData);

  @override
  final List<Map<String, dynamic>> addressData;

  @override
  String get gateway => '192.168.0.1';
}
