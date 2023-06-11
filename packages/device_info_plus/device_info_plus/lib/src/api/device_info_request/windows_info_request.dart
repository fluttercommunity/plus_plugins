import 'package:device_info_plus/src/model/windows_device_info.dart';

class WindowsInfo {
  dynamic platform;

  WindowsInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  WindowsDeviceInfo? _cachedWindowsDeviceInfo;
  Map<String, dynamic>? _cachedWindowsDeviceInfoMap;

  Future<WindowsDeviceInfo> info() async {
    _cachedWindowsDeviceInfo ??=
        await platform.deviceInfo() as WindowsDeviceInfo;
    return _cachedWindowsDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedWindowsDeviceInfoMap = _cachedWindowsDeviceInfo!.data;
    return _cachedWindowsDeviceInfoMap!;
  }
}
