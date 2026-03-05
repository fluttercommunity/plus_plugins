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

  /// Satellite: Device is connected via a highly constrained satellite link.
  ///
  /// On iOS and macOS, reported when [NWPath.isConstrained] is true. This
  /// covers both satellite connections and Low Data Mode enabled by the user.
  /// Appears alongside [mobile] (e.g. `[mobile, satellite]`).
  ///
  /// On Android 14+ (API 34), reported when [TRANSPORT_SATELLITE] capability
  /// is present. Appears as a standalone result.
  ///
  /// Not reported on other platforms.
  satellite,

  /// Other: Device is connected to an unknown network
  other
}
