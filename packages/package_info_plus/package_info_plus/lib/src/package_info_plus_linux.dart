import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

/// The Linux implementation of [PackageInfoPlatform].
class PackageInfoPlusLinuxPlugin extends PackageInfoPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    PackageInfoPlatform.instance = PackageInfoPlusLinuxPlugin();
  }

  /// Returns a map with the following keys:
  /// appName, packageName, version, buildNumber
  @override
  Future<PackageInfoData> getAll() async {
    final versionJson = await _getVersionJson();
    return PackageInfoData(
      appName: versionJson['app_name'] ?? '',
      version: versionJson['version'] ?? '',
      buildNumber: versionJson['build_number'] ?? '',
      packageName: versionJson['package_name'] ?? '',
      buildSignature: '',
    );
  }

  Future<Map<String, dynamic>> _getVersionJson() async {
    try {
      return jsonDecode(await File('version.json').readAsString());
    } catch (_) {
      return <String, dynamic>{};
    }
  }
}
