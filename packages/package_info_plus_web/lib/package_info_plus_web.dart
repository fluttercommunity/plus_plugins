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
    final url = Uri.parse(
      '${Uri.parse(window.document.baseUri!).removeFragment()}version.json',
    );

    final response = await get(url);
    final versionMap = _getVersionMap(response);

    return PackageInfoData(
      appName: versionMap['app_name'] ?? '',
      version: versionMap['version'] ?? '',
      buildNumber: versionMap['build_number'] ?? '',
      packageName: '',
    );
  }

  Map<String, dynamic> _getVersionMap(Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return <String, dynamic>{};
      }
    } else {
      return <String, dynamic>{};
    }
  }
}
