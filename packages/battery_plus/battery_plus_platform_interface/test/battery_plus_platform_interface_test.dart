import 'package:battery_plus_platform_interface/src/enums.dart';
import 'package:battery_plus_platform_interface/method_channel_battery_plus.dart';
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
          case 'isBatteryPresent':
            return true;
          case 'getBatteryLevel':
            return 100;
          case 'isInBatterySaveMode':
            return true;
          case 'getBatteryHealth':
            return 'BATTERY_HEALTH_GOOD';
          case 'getBatteryCapacity':
            return 100000;
          case 'getBatteryPluggedType':
            return 'BATTERY_PLUGGED_USB';
          case 'getBatteryTechnology':
            return 'Li-ion';
          case 'getBatteryTemperature':
            return 25.0;
          case 'getBatteryVoltage':
            return 5000;
          case 'getBatteryCurrentAverage':
            return 500;
          case 'getBatteryCurrentNow':
            return 500;
          case 'getBatteryRemainingCapacity':
            return 100000;
          case 'getBatteryScale':
            return 200000;
          case 'getBatteryChargeTimeRemaining':
            return 10000;
          default:
            return null;
        }
      });
      log.clear();
      MethodChannel(methodChannelBattery.eventChannel.name)
          .setMockMethodCallHandler((MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'listen':
            await ServicesBinding.instance!.defaultBinaryMessenger
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

    test('isBatteryPresent', () async {
      final result = await methodChannelBattery.isBatteryPresent;
      expect(result, true);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'isBatteryPresent',
            arguments: null,
          ),
        ],
      );
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

    test('getBatteryHealth', () async {
      final result = await methodChannelBattery.batteryHealth;
      expect(result, 'BATTERY_HEALTH_GOOD');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryHealth',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryCapacity', () async {
      final result = await methodChannelBattery.batteryCapacity;
      expect(result, 100000);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryCapacity',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryPluggedType', () async {
      final result = await methodChannelBattery.batteryPluggedType;
      expect(result, 'BATTERY_PLUGGED_USB');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryPluggedType',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryTechnology', () async {
      final result = await methodChannelBattery.batteryTechnology;
      expect(result, 'Li-ion');
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryTechnology',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryTemperature', () async {
      final result = await methodChannelBattery.batteryTemperature;
      expect(result, 25.0);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryTemperature',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryVoltage', () async {
      final result = await methodChannelBattery.batteryVoltage;
      expect(result, 5000);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryVoltage',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryCurrentAverage', () async {
      final result = await methodChannelBattery.batteryCurrentAverage;
      expect(result, 500);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryCurrentAverage',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryCurrentNow', () async {
      final result = await methodChannelBattery.batteryCurrentNow;
      expect(result, 500);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryCurrentNow',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryRemainingCapacity', () async {
      final result = await methodChannelBattery.batteryRemainingCapacity;
      expect(result, 100000);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryRemainingCapacity',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryScale', () async {
      final result = await methodChannelBattery.batteryScale;
      expect(result, 200000);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryScale',
            arguments: null,
          ),
        ],
      );
    });

    test('getBatteryChargeTimeRemaining', () async {
      final result = await methodChannelBattery.batteryChargeTimeRemaining;
      expect(result, 10000);
      expect(
        log,
        <Matcher>[
          isMethodCall(
            'getBatteryChargeTimeRemaining',
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
  });
}
