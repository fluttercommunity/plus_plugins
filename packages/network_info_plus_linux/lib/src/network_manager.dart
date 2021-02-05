import 'dart:async';

import 'package:dbus/dbus.dart';

// Used internally
// ignore_for_file: public_member_api_docs

const _kNetworkManager = 'org.freedesktop.NetworkManager';
const _kActiveConnection = _kNetworkManager + '.Connection.Active';
const _kDevice = _kNetworkManager + '.Device';
const _kWireless = _kDevice + '.Wireless';

const _kPath = '/org/freedesktop/NetworkManager';
const _kType = 'PrimaryConnectionType';

class NetworkManager extends DBusRemoteObject {
  NetworkManager(DBusClient client)
      : super(client, _kNetworkManager, DBusObjectPath(_kPath));

  factory NetworkManager.system() => NetworkManager(DBusClient.system());

  void dispose() => client?.close();

  Future<String> getPath() => _getString('PrimaryConnection', fallback: '/');

  Future<String> getType() => _getString(_kType);

  Future<String> _getString(String path, {String fallback = ''}) {
    return getProperty(_kNetworkManager, path)
        .then(
          (value) => (value as DBusString).value,
          onError: (error) => print(error),
        )
        .then((value) => value ?? fallback);
  }

  Stream<String> subscribeTypeChanged() {
    return subscribePropertiesChanged()
        .where((event) => event.changedProperties.containsKey(_kType))
        .map((event) => (event.changedProperties[_kType] as DBusString).value);
  }

  Future<NMConnection> createConnection() {
    return getPath().then((path) => NMConnection.fromPath(client, path));
  }
}

class NMConnection extends DBusRemoteObject {
  NMConnection(DBusClient client, {DBusObjectPath path})
      : super(client, _kNetworkManager, path);

  factory NMConnection.fromPath(DBusClient client, String path) {
    if (path == '/') return null;
    return NMConnection(client, path: DBusObjectPath(path));
  }

  Future<String> getId() {
    return getProperty(_kActiveConnection, 'Id')
        .then(
          (value) => (value as DBusString).value,
          onError: (error) => print(error),
        )
        .then((value) => value ?? '');
  }

  Future<List<String>> getDevices() {
    return getProperty(_kActiveConnection, 'Devices')
        .then(
          (value) => (value as DBusArray)
              .children
              .map((child) => (child as DBusObjectPath).value)
              .toList(),
          onError: (error) => print(error),
        )
        .then((value) => value ?? <String>[]);
  }

  Future<NMDevice> createDevice() {
    return getDevices().then((devices) {
      if (devices.isEmpty) return null;
      return NMDevice.fromPath(client, devices.first);
    });
  }
}

enum NMDeviceType { unknown, ethernet, wifi }

extension NMDeviceInt on int {
  int byteAt(int i) => (this >> (i * 8)) & 0xff;

  String toIp4() => '${byteAt(0)}.${byteAt(1)}.${byteAt(2)}.${byteAt(3)}';

  NMDeviceType toType() => NMDeviceType.values[this];
}

class NMDevice extends DBusRemoteObject {
  NMDevice(DBusClient client, {DBusObjectPath path})
      : super(client, _kNetworkManager, path);

  factory NMDevice.fromPath(DBusClient client, String path) {
    return NMDevice(client, path: DBusObjectPath(path));
  }

  Future<String> getIp4() {
    return getProperty(_kDevice, 'Ip4Address').then(
      (value) => (value as DBusUint32).value.toIp4(),
      onError: (error) => print(error),
    );
  }

  Future<NMDeviceType> getType() {
    return getProperty(_kDevice, 'DeviceType').then(
      (value) => (value as DBusUint32).value.toType(),
      onError: (error) => print(error),
    );
  }

  Future<NMWirelessDevice> asWirelessDevice() {
    return getType().then((type) {
      if (type != NMDeviceType.wifi) return null;
      return NMWirelessDevice(client, path: path);
    });
  }
}

class NMWirelessDevice extends DBusRemoteObject {
  NMWirelessDevice(DBusClient client, {DBusObjectPath path})
      : super(client, _kNetworkManager, path);

  Future<String> getHwAddress() {
    return getProperty(_kWireless, 'HwAddress').then(
      (value) => (value as DBusString).value,
      onError: (error) => print(error),
    );
  }
}
