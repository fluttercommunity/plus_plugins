import 'package:flutter_test/flutter_test.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';
import 'package:nm/nm.dart';

void main() {
  test('registered instance', () {
    NetworkInfoPlusLinuxPlugin.registerWith();
    expect(NetworkInfoPlatform.instance, isA<NetworkInfoPlusLinuxPlugin>());
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
}
