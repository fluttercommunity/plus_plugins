import 'package:battery_plus_linux/src/battery_plus_linux.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:upower/upower.dart';

import 'battery_plus_linux_test.mocks.dart';

@GenerateMocks([UPowerClient, UPowerDevice])
void main() {
  test('registered instance', () {
    BatteryPlusLinux.registerWith();
    expect(BatteryPlatform.instance, isA<BatteryPlusLinux>());
  });
  test('battery level', () async {
    final battery = BatteryPlusLinux();
    battery.createClient = () {
      return createMockClient(percentage: 56.78);
    };
    expect(battery.batteryLevel, completion(equals(57)));
  });

  test('battery state', () async {
    final battery = BatteryPlusLinux();
    battery.createClient = () {
      return createMockClient(state: UPowerDeviceState.charging);
    };
    expect(battery.batteryState, completion(BatteryState.charging));
  });

  test('battery state changes', () {
    final battery = BatteryPlusLinux();
    battery.createClient = () {
      final client = createMockClient(state: UPowerDeviceState.charging);
      final device = client.displayDevice;
      when(device.propertiesChanged).thenAnswer((_) {
        when(device.state).thenReturn(UPowerDeviceState.fullyCharged);
        return Stream.value(['State']);
      });
      return client;
    };
    expect(battery.onBatteryStateChanged,
        emitsInOrder([BatteryState.charging, BatteryState.full]));
  });
}

MockUPowerClient createMockClient({
  double? percentage,
  UPowerDeviceState? state,
}) {
  final device = MockUPowerDevice();
  if (percentage != null) {
    when(device.percentage).thenReturn(percentage);
  }
  if (state != null) {
    when(device.state).thenReturn(state);
  }

  final client = MockUPowerClient();
  when(client.displayDevice).thenReturn(device);
  return client;
}
