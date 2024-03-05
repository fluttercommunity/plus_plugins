import 'dart:async';

import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:meta/meta.dart';
import 'package:upower/upower.dart';

extension _ToBatteryState on UPowerDeviceState {
  BatteryState toBatteryState() {
    switch (this) {
      case UPowerDeviceState.charging:
        return BatteryState.charging;

      case UPowerDeviceState.discharging:
      case UPowerDeviceState.pendingDischarge:
        return BatteryState.discharging;

      case UPowerDeviceState.fullyCharged:
        return BatteryState.full;

      case UPowerDeviceState.pendingCharge:
        return BatteryState.connectedNotCharging;

      default:
        return BatteryState.unknown;
    }
  }
}

///
@visibleForTesting
typedef UPowerClientFactory = UPowerClient Function();

/// The Linux implementation of BatteryPlatform.
class BatteryPlusLinuxPlugin extends BatteryPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    BatteryPlatform.instance = BatteryPlusLinuxPlugin();
  }

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel {
    final client = createClient();
    return client
        .connect()
        .then((_) => client.displayDevice.percentage.round())
        .whenComplete(() => client.close());
  }

  /// Returns the current battery state.
  @override
  Future<BatteryState> get batteryState {
    final client = createClient();
    return client
        .connect()
        .then((_) => client.displayDevice.state.toBatteryState())
        .whenComplete(() => client.close);
  }

  /// Fires whenever the battery state changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged {
    _stateController ??= StreamController<BatteryState>.broadcast(
      onListen: _startListenState,
      onCancel: _stopListenState,
    );
    return _stateController!.stream.asBroadcastStream();
  }

  UPowerClient? _stateClient;
  StreamController<BatteryState>? _stateController;

  @visibleForTesting
  // ignore: public_member_api_docs, prefer_function_declarations_over_variables
  UPowerClientFactory createClient = () => UPowerClient();

  void _addState(UPowerDeviceState value) {
    _stateController!.add(value.toBatteryState());
  }

  Future<void> _startListenState() async {
    _stateClient ??= createClient();
    await _stateClient!
        .connect()
        .then((_) => _addState(_stateClient!.displayDevice.state));
    _stateClient!.displayDevice.propertiesChanged.listen((properties) {
      if (properties.contains('State')) {
        _addState(_stateClient!.displayDevice.state);
      }
    });
  }

  void _stopListenState() {
    _stateController?.close();
    _stateClient?.close();
    _stateClient = null;
  }
}
