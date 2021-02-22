import 'package:battery_plus_linux/src/battery_plus_linux_real.dart';
import 'package:battery_plus_linux/src/upower_device.dart';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:dbus/src/dbus_client.dart';
import 'package:dbus/src/dbus_introspect.dart';
import 'package:dbus/src/dbus_method_response.dart';
import 'package:dbus/src/dbus_remote_object.dart';
import 'package:dbus/src/dbus_value.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('battery level', () async {
    final battery = BatteryPlusLinux();
    battery.createDevice = () {
      return MockDevice();
    };
    expect(battery.batteryLevel, completion(equals(57)));
  });

  test('battery state changes', () {
    final battery = BatteryPlusLinux();
    battery.createDevice = () {
      return MockDevice();
    };
    expect(battery.onBatteryStateChanged,
        emitsInOrder([BatteryState.charging, BatteryState.full]));
  });
}

class MockDevice implements UPowerDevice {

  @override
  Future<DBusMethodResponse> callMethod(String? interface, String member, List<DBusValue> values) async {
    throw UnimplementedError();
  }

  @override
  DBusClient get client => throw UnimplementedError();

  @override
  String get destination => throw UnimplementedError();

  @override
  void dispose() {
  }

  @override
  Future<Map<String, DBusValue>> getAllProperties(String interface) {
    throw UnimplementedError();
  }

  @override
  Future<Map<DBusObjectPath, Map<String, Map<String, DBusValue>>>> getManagedObjects() {
    throw UnimplementedError();
  }

  @override
  Future<double> getPercentage() {
    return Future.value(56.78);
  }

  @override
  Future<DBusValue> getProperty(String interface, String name) {
    throw UnimplementedError();
  }

  @override
  Future<UPowerBatteryState> getState() {
    return Future.value(UPowerBatteryState.charging);
  }

  @override
  Future<DBusIntrospectNode> introspect() {
    throw UnimplementedError();
  }

  @override
  DBusObjectPath get path => throw UnimplementedError();

  @override
  Future<void> setProperty(String interface, String name, DBusValue value) {
    throw UnimplementedError();
  }

  @override
  Stream<DBusSignal> subscribeObjectManagerSignals() {
    throw UnimplementedError();
  }

  @override
  Stream<DBusPropertiesChangedSignal> subscribePropertiesChanged() {
    throw UnimplementedError();
  }

  @override
  Stream<DBusSignal> subscribeSignal(String interface, String member) {
    throw UnimplementedError();
  }

  @override
  Stream<UPowerBatteryState> subscribeStateChanged() {
    return Stream.value(UPowerBatteryState.fullyCharged);
  }

}
