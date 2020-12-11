import 'package:battery_plus_linux/src/battery_plus_linux_real.dart';
import 'package:battery_plus_linux/src/upower_device.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDevice extends Mock implements UPowerDevice {}

void main() {
  test('battery level', () async {
    final battery = BatteryPlusLinux();
    battery.createDevice = () {
      final device = MockDevice();
      when(device.getPercentage()).thenAnswer((_) => Future.value(56.78));
      return device;
    };
    expect(battery.batteryLevel, completion(equals(57)));
  });

  test('battery state changes', () {
    final battery = BatteryPlusLinux();
    battery.createDevice = () {
      final device = MockDevice();
      when(device.getState()).thenAnswer((_) {
        return Future.value(UPowerBatteryState.charging);
      });
      when(device.subscribeStateChanged()).thenAnswer((_) {
        return Stream.value(UPowerBatteryState.fullyCharged);
      });
      return device;
    };
    expect(battery.onBatteryStateChanged,
        emitsInOrder([BatteryState.charging, BatteryState.full]));
  });
}
