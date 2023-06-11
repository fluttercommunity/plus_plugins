import 'package:device_info_plus/src/model/android_device_info.dart';

class AndroidInfo {
  dynamic platform;

  AndroidInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  AndroidDeviceInfo? _cachedAndroidDeviceInfo;
  Map<String, dynamic>? _cachedAndroidDeviceInfoMap;

  Future<AndroidDeviceInfo> info() async {
    _cachedAndroidDeviceInfo ??=
        AndroidDeviceInfo.fromMap((await platform.deviceInfo()).data);
    return _cachedAndroidDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedAndroidDeviceInfoMap ??= _cachedAndroidDeviceInfo!.data;
    return _cachedAndroidDeviceInfoMap!;
  }
}
