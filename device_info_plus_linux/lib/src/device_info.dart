import 'dart:async';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:meta/meta.dart';

class DeviceInfoLinux extends DeviceInfoPlatform {
  LinuxDeviceInfo _cache;
  final FileSystem _fileSystem;

  DeviceInfoLinux({@visibleForTesting FileSystem fileSystem})
      : _fileSystem = fileSystem ?? LocalFileSystem();

  @override
  Future<LinuxDeviceInfo> linuxInfo() async {
    return _cache ??= await _getInfo();
  }

  Future<LinuxDeviceInfo> _getInfo() async {
    final rel = await _tryReadKeyValues('/etc/os-release') ??
        await _tryReadKeyValues('/usr/lib/os-release') ??
        await _tryReadKeyValues('/etc/lsb-release') ??
        {};

    return LinuxDeviceInfo(
      name: rel['NAME'] ?? 'Linux',
      version: rel['VERSION'] ?? rel['LSB_VERSION'],
      id: rel['ID'] ?? rel['DISTRIB_ID'] ?? 'linux',
      idLike: rel['ID_LIKE']?.split(' '),
      versionCodename: rel['VERSION_CODENAME'] ?? rel['DISTRIB_CODENAME'],
      versionId: rel['VERSION_ID'] ?? rel['DISTRIB_RELEASE'],
      prettyName: rel['PRETTY_NAME'] ?? rel['DISTRIB_DESCRIPTION'] ?? 'Linux',
      buildId: rel['BUILD_ID'],
      variant: rel['VARIANT'],
      variantId: rel['VARIANT_ID'],
      hostname: await _tryReadValue('/etc/hostname'),
      machineId: await _tryReadValue('/etc/machine-id'),
    );
  }

  Future<String> _tryReadValue(String path) async {
    return _fileSystem
        .file(path)
        .readAsString()
        .then((str) => str.trim())
        .catchError((_) => null);
  }

  Future<Map<String, String>> _tryReadKeyValues(String path) async {
    return _fileSystem
        .file(path)
        .readAsLines()
        .then((lines) => lines.toKeyValues())
        .catchError((_) => null);
  }
}

extension _Unquote on String {
  String removePrefix(String prefix) {
    if (!startsWith(prefix)) return this;
    return substring(prefix.length);
  }

  String removeSuffix(String suffix) {
    if (!endsWith(suffix)) return this;
    return substring(0, length - suffix.length);
  }

  String unquote() {
    return removePrefix('"').removeSuffix('"');
  }
}

extension _KeyValues on List<String> {
  Map<String, String> toKeyValues() {
    return Map.fromEntries(map((line) {
      final parts = line.split('=');
      if (parts.length != 2) return MapEntry(line, null);
      return MapEntry(parts.first, parts.last.unquote());
    }));
  }
}
