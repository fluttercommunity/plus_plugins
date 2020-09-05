import 'package:battery_plus_platform_interface/src/enums.dart';
import 'package:battery_plus_platform_interface/src/method_channel_battery_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelBatteryPlus', () {
    final List<MethodCall> log = <MethodCall>[];
    MethodChannelBatteryPlus methodChannelBatteryPlus;

    setUp(() async {
      methodChannelBatteryPlus = MethodChannelBatteryPlus();

      methodChannelBatteryPlus.methodChannel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getBatteryLevel':
            return 100;
          default:
            return null;
        }
      });
      log.clear();
      MethodChannel(methodChannelBatteryPlus.eventChannel.name)
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'listen':
            await ServicesBinding.instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannelBatteryPlus.eventChannel.name,
              methodChannelBatteryPlus.eventChannel.codec
                  .encodeSuccessEnvelope('full'),
              (_) {},
            );
            break;
          case 'cancel':
          default:
            return null;
        }
      });
    });

    test('onBatteryChanged', () async {
      final BatteryState result =
          await methodChannelBatteryPlus.onBatteryStateChanged.first;
      expect(result, BatteryState.full);
    });

    test('getBatteryLevel', () async {
      final int result = await methodChannelBatteryPlus.batteryLevel;
      expect(result, 100);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryLevel',
            arguments: null,
          ),
        ],
      );
    });
  });
}
