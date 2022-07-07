/// The base class for platform's device info.
abstract class BaseDeviceInfo {
  /// Serializes device info properties to a json
  /// this method will be called by `jsonEncode` in [dart:convert]
  Map<String, Object?> toJson();
}
