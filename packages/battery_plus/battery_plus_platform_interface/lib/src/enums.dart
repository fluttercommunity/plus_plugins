/// Indicates the current battery state.
enum BatteryState {
  /// The battery is fully charged.
  full,

  /// The battery is currently charging.
  charging,

  /// Device is connected to external power source, but not charging the battery.
  /// Usually happens when device has charge limit enabled and this limit is reached.
  /// Available on MacOS and Android platforms only.
  connectedNotCharging,

  /// The battery is currently losing energy.
  discharging,

  /// The state of the battery is unknown.
  unknown;
}
