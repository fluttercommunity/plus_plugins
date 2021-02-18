import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

/// A stub implementation to satisfy compilation of multi-platform packages that
/// depend on device_info_plus_windows. This should never actually be created.
///
/// Notably, because device_info_plus needs to manually register
/// device_info_plus_windows, anything with a transitive dependency on
/// device_info_plus will also depend on device_info_plus_windows, not just at
/// the pubspec level but the code level.
class DeviceInfoWindows extends DeviceInfoPlatform {
  /// Errors on attempted instantiation of the stub. It exists only to satisfy
  /// compile-time dependencies, and should never actually be created.
  DeviceInfoWindows() {
    assert(false);
  }

  /// Stub
  @override
  Future<WindowsDeviceInfo>? windowsInfo() {
    return null;
  }
}
