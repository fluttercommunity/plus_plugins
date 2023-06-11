import 'package:device_info_plus/src/model/web_browser_info.dart';

class WebInfo {
  dynamic platform;

  WebInfo({required this.platform});

  /// This information does not change from call to call. Cache it.
  WebBrowserInfo? _cachedWebDeviceInfo;
  Map<String, dynamic>? _cachedWebDeviceInfoMap;

  Future<WebBrowserInfo> info() async {
    _cachedWebDeviceInfo ??= await platform.deviceInfo() as WebBrowserInfo;
    return _cachedWebDeviceInfo!;
  }

  Map<String, dynamic> getInfoAsMap() {
    info();
    _cachedWebDeviceInfoMap = _cachedWebDeviceInfo!.data;
    return _cachedWebDeviceInfoMap!;
  }
}
