/// Connection status check result.
enum ConnectivityResult {
  /// Bluetooth: Device connected via bluetooth
  bluetooth,

  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Ethernet: Device connected to ethernet network
  ethernet,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none,

  /// VPN: Device connected to a VPN
  ///
  /// Note for iOS and macOS:
  /// There is no separate network interface type for [vpn],
  /// it returns [other] type.
  /// Both in the simulator and on any device.
  vpn,

  /// Other: Device is connected to an unknown network
  other
}
