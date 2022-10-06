import 'package:flutter_test/flutter_test.dart';
import 'package:sensers_plus2/sensers_plus2.dart';
import 'package:sensers_plus2/sensers_plus2_platform_interface.dart';
import 'package:sensers_plus2/sensers_plus2_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSensersPlus2Platform
    with MockPlatformInterfaceMixin
    implements SensersPlus2Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SensersPlus2Platform initialPlatform = SensersPlus2Platform.instance;

  test('$MethodChannelSensersPlus2 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSensersPlus2>());
  });

  test('getPlatformVersion', () async {
    SensersPlus2 sensersPlus2Plugin = SensersPlus2();
    MockSensersPlus2Platform fakePlatform = MockSensersPlus2Platform();
    SensersPlus2Platform.instance = fakePlatform;

    expect(await sensersPlus2Plugin.getPlatformVersion(), '42');
  });
}
