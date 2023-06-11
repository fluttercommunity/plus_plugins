import 'package:device_info_plus/src/model/macos_device_info.dart';

class MacOsInfo {
  dynamic platform;

  MacOsInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  MacOsDeviceInfo? _cachedMacOsDeviceInfo;
  Map<String, dynamic>? _cachedMacOsDeviceInfoMap;

  Future<MacOsDeviceInfo> info() async {
    _cachedMacOsDeviceInfo ??=
        MacOsDeviceInfo.fromMap((await platform.deviceInfo()).data);

    return _cachedMacOsDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedMacOsDeviceInfoMap = _cachedMacOsDeviceInfo!.data;
    return _cachedMacOsDeviceInfoMap!;
  }
}
