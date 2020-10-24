import 'dart:convert';
import 'dart:html';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

/// The web implementation of [PackageInfoPlatform].
///
/// This class implements the `package:package_info_plus` functionality for the web.
class PackageInfoPlugin extends PackageInfoPlatform {
  /// Registers this class as the default instance of [PackageInfoPlatform].
  static void registerWith(Registrar registrar) {
    PackageInfoPlatform.instance = PackageInfoPlugin();
  }

  @override
  Future<PackageInfoData> getAll() async {
    String url =
        "${window.location.protocol}//${window.location.hostname}:${window.location.port}/version.json";

    final response = await get(url);
    if (response.statusCode == 200) {
      try {
        final versionMap = jsonDecode(response.body);
        return PackageInfoData(
          appName: versionMap['app_name'],
          version: versionMap['version'],
          buildNumber: versionMap['build_number'],
        );
      } catch (e) {
        return PackageInfoData();
      }
    } else {
      return PackageInfoData();
    }
  }
}
