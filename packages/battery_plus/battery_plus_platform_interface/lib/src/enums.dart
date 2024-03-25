/// Indicates the current battery state.
enum BatteryState {
  /// The battery is fully charged.
  full,

  /// The battery is currently charging.
  charging,

  /// Device is connected to external power source, but not charging the battery.
  ///
  /// Usually happens when device has charge limit enabled and this limit is reached.
  /// Also, battery might be in this state if connected power source isn't powerful enough to charge the battery.
  ///
  /// Available on Android, MacOS and Linux platforms only.
  connectedNotCharging,

  /// The battery is currently losing energy.
  discharging,

  /// The state of the battery is unknown.
  unknown;
}

/// Indicates the current power source type.
///
/// When the [BatteryState] is in a state of
///  [connectedNotCharging],[charging] or [full].
///
/// We can get some extra info battery info on how it is powered.
enum PowerSourceType {
  /// Power source is an AC charger.
  ac('ac'),

  /// Power source is dock.
  dock('dock'),

  /// Power source is a USB port.
  usb('usb'),

  /// Power source is wireless.
  wireless('wireless'),

  /// Power source is battery
  battery('battery'),

  /// Power source could not be determined.
  unknown('unknown');

  /// The known string value communicated from the channel.
  final String _state;

  const PowerSourceType(this._state);

  /// Parse the power source string value to the given power source type.
  static PowerSourceType parsePowerSource(String? value) {
    return PowerSourceType.values.firstWhere(
      (sourceType) => sourceType._state == value,
      orElse: () => PowerSourceType.unknown,
    );
  }
}
