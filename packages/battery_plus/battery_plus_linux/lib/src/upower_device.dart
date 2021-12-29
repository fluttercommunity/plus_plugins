import 'dart:developer' as developer;

import 'package:dbus/dbus.dart';

const _kInterface = 'org.freedesktop.UPower';
const _kDeviceAddress = 'org.freedesktop.UPower.Device';
const _kDisplayDevicePath = '/org/freedesktop/UPower/devices/DisplayDevice';

// Used internally
// ignore_for_file: public_member_api_docs

enum UPowerBatteryState {
  unknown,
  charging,
  discharging,
  empty,
  fullyCharged,
  pendingCharge,
  pendingDischarge
}

extension UPowerBatteryStateInt on int {
  UPowerBatteryState toBatteryState() => UPowerBatteryState.values[this];
}

typedef UPowerBatteryStateCallback = void Function(UPowerBatteryState state);

class UPowerDevice extends DBusRemoteObject {
  UPowerDevice._({
    required DBusClient client,
    required DBusObjectPath path,
  }) : super(client, name: _kInterface, path: path);

  factory UPowerDevice.display([DBusClient? client]) {
    return UPowerDevice._(
      client: client ?? DBusClient.system(),
      path: DBusObjectPath(_kDisplayDevicePath),
    );
  }

  void dispose() => client.close();

  Future<double> getPercentage() {
    return getProperty(_kDeviceAddress, 'Percentage').then(
      (value) => (value as DBusDouble).value,
      onError: (e) => developer.log("Couldn't get percentage", error: e),
    );
  }

  Future<UPowerBatteryState> getState() {
    return getProperty(_kDeviceAddress, 'State').then(
      (value) => (value as DBusUint32).value.toBatteryState(),
      onError: (e) => developer.log("Couldn't get battery state", error: e),
    );
  }

  Stream<UPowerBatteryState> subscribeStateChanged() {
    return propertiesChanged
        .where((event) => event.changedProperties.containsKey('State'))
        .map((event) => (event.changedProperties['State'] as DBusUint32)
            .value
            .toBatteryState());
  }
}
