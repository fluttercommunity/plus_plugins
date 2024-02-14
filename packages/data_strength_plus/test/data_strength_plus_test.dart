import 'package:flutter_test/flutter_test.dart';
import 'package:data_strength_plus/data_strength_plus.dart';
import 'package:data_strength_plus/data_strength_plus_platform_interface.dart';
import 'package:data_strength_plus/data_strength_plus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDataStrengthPlusPlatform
    with MockPlatformInterfaceMixin
    implements DataStrengthPlusPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<int?> getMobileSignalStrength() {
    // TODO: implement getMobileSignalStrength
    throw UnimplementedError();
  }

  @override
  Future<int?> getWifiLinkSpeed() {
    // TODO: implement getWifiLinkSpeed
    throw UnimplementedError();
  }

  @override
  Future<int?> getWifiSignalStrength() {
    // TODO: implement getWifiSignalStrength
    throw UnimplementedError();
  }
}

void main() {
  final DataStrengthPlusPlatform initialPlatform =
      DataStrengthPlusPlatform.instance;

  test('$MethodChannelDataStrengthPlus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDataStrengthPlus>());
  });

  test('getPlatformVersion', () async {
    DataStrengthPlus dataStrengthPlusPlugin = DataStrengthPlus();
    MockDataStrengthPlusPlatform fakePlatform = MockDataStrengthPlusPlatform();
    DataStrengthPlusPlatform.instance = fakePlatform;

    expect(await dataStrengthPlusPlugin.getPlatformVersion(), '42');
  });
}
