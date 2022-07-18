/// The base class for platform's device info.
abstract class BaseDeviceInfo {
  /// Serializes device info properties to a json compatible map.
  /// This method will be called by `jsonEncode` in [dart:convert].
  Map<String, Object?> toJson();

  /// Serializes device info properties to a map.
  Map<String, Object?> toMap();
}
