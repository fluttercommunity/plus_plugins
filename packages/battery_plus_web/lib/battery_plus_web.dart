import 'dart:async';
import 'dart:html' as html show window, BatteryManager, Navigator;
import 'dart:js';
import 'dart:js_util';
import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// The web implementation of the BatteryPlatform of the Battery plugin.
class BatteryPlusPlugin extends BatteryPlatform {
  /// Constructs a BatteryPlusPlugin.
  BatteryPlusPlugin(html.Navigator navigator)
      : _getBattery = navigator.getBattery;

  /// A check to determine if this version of the plugin can be used.
  // ignore: unnecessary_null_comparison
  bool get isSupported => html.window.navigator.getBattery != null;

  late final Future<dynamic> Function() _getBattery;

  /// Factory method that initializes the Battery plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    BatteryPlatform.instance = BatteryPlusPlugin(html.window.navigator);
  }

  /// Returns the current battery level in percent.
  @override
  Future<int> get batteryLevel async {
    if (isSupported) {
      //  level is a number representing the system's battery charge level scaled to a value between 0.0 and 1.0
      final batteryManager = await _getBattery() as html.BatteryManager;
      final level = batteryManager.level ?? 0;
      return level * 100 as int;
    }
    return 0;
  }

  StreamController<BatteryState>? _batteryChangeStreamController;
  late Stream<BatteryState> _batteryChange;

  /// Returns a Stream of BatteryState changes.
  @override
  Stream<BatteryState> get onBatteryStateChanged {
    if (_batteryChangeStreamController == null && isSupported) {
      _batteryChangeStreamController = StreamController<BatteryState>();

      _getBattery().then(
        (battery) {
          _batteryChangeStreamController!
              .add(_checkBatteryChargingState(battery.charging));
          setProperty(
            battery,
            'onchargingchange',
            allowInterop(
              (event) {
                _batteryChangeStreamController!
                    .add(_checkBatteryChargingState(battery.charging));
              },
            ),
          );
        },
      );

      _batteryChange =
          _batteryChangeStreamController!.stream.asBroadcastStream();
    }
    return _batteryChange;
  }

  BatteryState _checkBatteryChargingState(bool charging) {
    if (charging) {
      return BatteryState.charging;
    } else {
      return BatteryState.discharging;
    }
  }
}
