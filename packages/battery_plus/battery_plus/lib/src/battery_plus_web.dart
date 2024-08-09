import 'dart:async';
import 'dart:js_interop';

import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart';

/// The web implementation of the BatteryPlatform of the Battery plugin.
///
/// The Battery Status API is not supported by Firefox and Safari.
/// Therefore, when using this plugin, recommend that test not only in Chrome but also in Firefox and Safari.
/// In some environments, accessing this plugin from Firefox or Safari will cause unexpected exception.
/// If an unexpected Exception occurs, try-catch at the point where the method is being called.
class BatteryPlusWebPlugin extends BatteryPlatform {
  /// Constructs a BatteryPlusPlugin.
  BatteryPlusWebPlugin();

  /// Return [BatteryManager] if the BatteryManager API is supported by the User Agent.
  Future<BatteryManager?> _getBatteryManager() async {
    try {
      return await window.navigator.getBattery().toDart;
    } on NoSuchMethodError catch (_) {
      // BatteryManager API is not supported this User Agent.
      return null;
    } on Object catch (_) {
      // Unexpected exception occurred.
      return null;
    }
  }

  /// Factory method that initializes the Battery plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    BatteryPlatform.instance = BatteryPlusWebPlugin();
  }

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel async {
    final batteryManager = await _getBatteryManager();
    if (batteryManager == null) {
      return 0;
    }

    // level is a number representing the system's battery charge level scaled to a value between 0.0 and 1.0
    final level = batteryManager.level;
    return level * 100 as int;
  }

  /// Returns the current battery state.
  @override
  Future<BatteryState> get batteryState async {
    final batteryManager = await _getBatteryManager();
    if (batteryManager == null) {
      return BatteryState.unknown;
    }

    return _checkBatteryChargingState(batteryManager.charging);
  }

  StreamController<BatteryState>? _batteryChangeStreamController;
  Stream<BatteryState>? _batteryChange;

  /// Returns a Stream of BatteryState changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged async* {
    final batteryManager = await _getBatteryManager();
    if (batteryManager == null) {
      yield BatteryState.unknown;
      return;
    }

    if (_batteryChange != null) {
      yield* _batteryChange!;
      return;
    }

    _batteryChangeStreamController = StreamController<BatteryState>();
    _batteryChangeStreamController?.add(
      _checkBatteryChargingState(batteryManager.charging),
    );

    batteryManager.onchargingchange = (Event _) {
      _batteryChangeStreamController?.add(
        _checkBatteryChargingState(batteryManager.charging),
      );
    }.toJS;

    _batteryChangeStreamController?.onCancel = () {
      _batteryChangeStreamController?.close();

      _batteryChangeStreamController = null;
      _batteryChange = null;
    };

    _batteryChange = _batteryChangeStreamController!.stream.asBroadcastStream();
    yield* _batteryChange!;
  }

  BatteryState _checkBatteryChargingState(bool charging) {
    if (charging) {
      return BatteryState.charging;
    } else {
      return BatteryState.discharging;
    }
  }
}
