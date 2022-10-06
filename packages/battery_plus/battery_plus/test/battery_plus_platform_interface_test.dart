import 'package:battery_plus/src/battery_plus_method_channel.dart';
import 'package:battery_plus/src/enums.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$MethodChannelBattery', () {
    final log = <MethodCall>[];
    late MethodChannelBattery methodChannelBattery;

    setUp(() async {
      methodChannelBattery = MethodChannelBattery();

      methodChannelBattery.methodChannel
          .setMockMethodCallHandler((MethodCall methodCall) async {
        log.add(methodCall);
        switch (methodCall.method) {
          case 'getBatteryLevel':
            return 100;
          case 'isInBatterySaveMode':
            return true;
          case 'getBatteryState':
            return 'charging';
          default:
            return null;
        }
      });
      log.clear();
      MethodChannel(methodChannelBattery.eventChannel.name)
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'listen':
            await ServicesBinding.instance.defaultBinaryMessenger
                .handlePlatformMessage(
              methodChannelBattery.eventChannel.name,
              methodChannelBattery.eventChannel.codec
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
      final result = await methodChannelBattery.onBatteryStateChanged.first;
      expect(result, BatteryState.full);
    });

    test('getBatteryLevel', () async {
      final result = await methodChannelBattery.batteryLevel;
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

    test('isInBatterySaveMode', () async {
      final result = await methodChannelBattery.isInBatterySaveMode;
      expect(result, true);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'isInBatterySaveMode',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryState', () async {
      final result = await methodChannelBattery.batteryState;
      expect(result, BatteryState.charging);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryState',
            arguments: null,
          ),
        ],
      );
    });
  });
}
