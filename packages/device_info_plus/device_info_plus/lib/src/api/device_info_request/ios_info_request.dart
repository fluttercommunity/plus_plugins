import 'package:device_info_plus/src/model/ios_device_info.dart';

class IosInfo {
  dynamic platform;

  IosInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  IosDeviceInfo? _cachedIosDeviceInfo;
  Map<String, dynamic>? _cachedIosDeviceInfoMap;

  Future<IosDeviceInfo> info() async {
    _cachedIosDeviceInfo ??=
        IosDeviceInfo.fromMap((await platform.deviceInfo()).data);
    return _cachedIosDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedIosDeviceInfoMap ??= _cachedIosDeviceInfo!.data;
    return _cachedIosDeviceInfoMap!;
  }
}
