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
  /// Note that on iOS and macOS comes [other], not [vpn]
  vpn,

  /// OTHER: Device connected to any unknown network
  other
}
