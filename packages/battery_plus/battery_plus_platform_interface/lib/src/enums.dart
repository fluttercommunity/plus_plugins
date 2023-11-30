/// Indicates the current battery state.
enum BatteryState {
  /// The battery is completely full of energy.
  full,

  /// The battery is currently storing energy.
  charging,

  /// The battery is currently losing energy.
  discharging,

  /// The battery is not charging.
  notCharging,

  /// The state of the battery is unknown.
  unknown
}
