import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensers_plus2/sensers_plus2_method_channel.dart';

void main() {
  MethodChannelSensersPlus2 platform = MethodChannelSensersPlus2();
  const MethodChannel channel = MethodChannel('sensers_plus2');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
