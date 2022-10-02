/// The base class for platform's device info.
abstract class BaseDeviceInfo {
  /// Serializes device info properties to a map.
  @Deprecated('[toMap] method will be discontinued')
  Map<String, dynamic> toMap();
}
