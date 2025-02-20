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
    final exeAttributes = await _getExeAttributes(exePath);

    return PackageInfoData(
      appName: versionJson['app_name'] ?? '',
      version: versionJson['version'] ?? '',
      buildNumber: versionJson['build_number'] ?? '',
      packageName: versionJson['package_name'] ?? '',
      buildSignature: '',
      installTime: exeAttributes.created,
      updateTime: exeAttributes.modified,
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

  Future<({DateTime? created, DateTime? modified})> _getExeAttributes(
      String exePath) async {
    try {
      final statResult = await Process.run(
        'stat',
        // birth time and last modification time
        ['-c', '%W,%Y', exePath],
        stdoutEncoding: utf8,
      );

      if (statResult.exitCode != 0) {
        return await _fallbackAttributes(exePath);
      }

      final String stdout =
          statResult.stdout is String ? statResult.stdout : '';

      if (stdout.split(',').length != 2) {
        return await _fallbackAttributes(exePath);
      }

      final [creationMillis, modificationMillis] = stdout.split(',');

      // birth time is 0 if it is unknown
      final creationTime = _parseSecondsString(
        creationMillis,
        allowZero: false,
      );
      final modificationTime = _parseSecondsString(modificationMillis);

      return (
        created: creationTime,
        modified: modificationTime,
      );
    } catch (_) {
      return (created: null, modified: null);
    }
  }

  Future<({DateTime created, DateTime modified})> _fallbackAttributes(
      String exePath) async {
    final modifiedTime = await File(exePath).lastModified();

    return (created: modifiedTime, modified: modifiedTime);
  }

  DateTime? _parseSecondsString(String? secondsString,
      {bool allowZero = true}) {
    if (secondsString == null) {
      return null;
    }

    final millis = int.tryParse(secondsString);

    if (millis == null || millis == 0 && !allowZero) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(millis * 1000);
  }
}
