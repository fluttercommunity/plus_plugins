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
  test('registered instance', () {
    BatteryPlusLinux.registerWith();
    expect(BatteryPlatform.instance, isA<BatteryPlusLinux>());
  });
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
  Future<DBusMethodSuccessResponse> callMethod(
    String? interface,
    String member,
    Iterable<DBusValue> values, {
    DBusSignature? replySignature,
    bool noReplyExpected = false,
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    throw UnimplementedError();
  }

  @override
  DBusClient get client => throw UnimplementedError();

  @override
  String get destination => throw UnimplementedError();

  @override
  void dispose() {}

  @override
  Future<Map<String, DBusValue>> getAllProperties(String interface) {
    throw UnimplementedError();
  }

  @override
  Future<double> getPercentage() {
    return Future.value(56.78);
  }

  @override
  Future<DBusValue> getProperty(
    String interface,
    String name, {
    DBusSignature? signature,
  }) {
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
  Stream<DBusPropertiesChangedSignal> get propertiesChanged {
    throw UnimplementedError();
  }

  @override
  set propertiesChanged(Stream<DBusPropertiesChangedSignal> propertiesChanged) {
    throw UnimplementedError();
  }

  @override
  Stream<UPowerBatteryState> subscribeStateChanged() {
    return Stream.value(UPowerBatteryState.fullyCharged);
  }
}
