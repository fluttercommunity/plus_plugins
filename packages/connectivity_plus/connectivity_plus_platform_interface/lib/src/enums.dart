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
  /// There is no separate network interface type for [vpn].
  /// It returns [other] on any device (also simulator).
  vpn,

  /// Other: Device is connected to an unknown network
  other
}
