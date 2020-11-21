import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path/path.dart' as path;

/// The Linux implementation of [PackageInfoPlatform].
class PackageInfoLinux extends PackageInfoPlatform {
  /// Returns a map with the following keys:
  /// appName, packageName, version, buildNumber
  @override
  Future<PackageInfoData> getAll() async {
    try {
      final exePath = File('/proc/self/exe').resolveSymbolicLinksSync();
      final appPath = path.dirname(exePath);
      final assetPath = path.join(appPath, 'data', 'flutter_assets');
      final versionPath = path.join(assetPath, 'version.json');
      final versionJson = jsonDecode(File(versionPath).readAsStringSync());
      return PackageInfoData(
        appName: versionJson['app_name'],
        version: versionJson['version'],
        buildNumber: versionJson['build_number'],
      );
    } catch (e) {
      return PackageInfoData();
    }
  }
}
