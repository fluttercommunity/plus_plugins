import 'dart:convert';

/// The base class for platform's device info.
abstract class BaseDeviceInfo {
  /// Serializes device info properties to a map.
  Map<String, dynamic> toMap();

  /// `toJson()` returns a JSON string representation of [BaseDeviceInfo] Model.
  String toJson() => jsonEncode(toMap());
}
