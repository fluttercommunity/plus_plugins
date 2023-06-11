import 'package:device_info_plus/src/model/linux_device_info.dart';

class LinuxInfo {
  dynamic platform;

  LinuxInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  LinuxDeviceInfo? _cachedLinuxDeviceInfo;
  Map<String, dynamic>? _cachedLinuxDeviceInfoMap;

  Future<LinuxDeviceInfo> info() async {
    _cachedLinuxDeviceInfo ??= await platform.deviceInfo() as LinuxDeviceInfo;
    return _cachedLinuxDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedLinuxDeviceInfoMap = _cachedLinuxDeviceInfo!.data;
    return _cachedLinuxDeviceInfoMap!;
  }
}
