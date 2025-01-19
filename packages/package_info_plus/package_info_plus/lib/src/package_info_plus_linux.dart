import 'dart:convert';
import 'dart:io';

import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:path/path.dart' as path;

/// The Linux implementation of [PackageInfoPlatform].
class PackageInfoPlusLinuxPlugin extends PackageInfoPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    PackageInfoPlatform.instance = PackageInfoPlusLinuxPlugin();
  }

  /// Returns a map with the following keys:
  /// appName, packageName, version, buildNumber
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async {
    final exePath = await File('/proc/self/exe').resolveSymbolicLinks();

    final versionJson = await _getVersionJson(exePath);
    final installTime = await _getInstallTime(exePath);

    return PackageInfoData(
      appName: versionJson['app_name'] ?? '',
      version: versionJson['version'] ?? '',
      buildNumber: versionJson['build_number'] ?? '',
      packageName: versionJson['package_name'] ?? '',
      buildSignature: '',
      installTime: installTime,
    );
  }

  Future<Map<String, dynamic>> _getVersionJson(String exePath) async {
    try {
      final appPath = path.dirname(exePath);
      final assetPath = path.join(appPath, 'data', 'flutter_assets');
      final versionPath = path.join(assetPath, 'version.json');

      return jsonDecode(await File(versionPath).readAsString());
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  Future<DateTime?> _getInstallTime(String exePath) async {
    try {
      final statResult = await Process.run(
        'stat',
        ['-c', '%W', exePath],
        stdoutEncoding: utf8,
      );

      if (statResult.exitCode == 0 && int.tryParse(statResult.stdout) != null) {
        final creationTimeSeconds = int.parse(statResult.stdout) * 1000;

        return DateTime.fromMillisecondsSinceEpoch(creationTimeSeconds);
      }

      return await File(exePath).lastModified();
    } catch (_) {
      return null;
    }
  }
}
