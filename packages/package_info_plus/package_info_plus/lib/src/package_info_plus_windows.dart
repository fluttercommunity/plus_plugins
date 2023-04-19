/// The Windows implementation of `package_info_plus`.
library package_info_plus_windows;

import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:win32/win32.dart';

part 'file_version_info.dart';

/// The Windows implementation of [PackageInfoPlatform].
class PackageInfoPlusWindowsPlugin extends PackageInfoPlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    PackageInfoPlatform.instance = PackageInfoPlusWindowsPlugin();
  }

  /// Returns a map with the following keys:
  /// appName, packageName, version, buildNumber
  @override
  Future<PackageInfoData> getAll() {
    String resolvedExecutable = Platform.resolvedExecutable;
    if (resolvedExecutable.startsWith(r"UNC\")){
      resolvedExecutable = resolvedExecutable.replaceFirst(r"UNC\", r"\\");
    }
    final info = _FileVersionInfo(resolvedExecutable);
    final versions = info.productVersion!.split('+');
    final data = PackageInfoData(
      appName: info.productName ?? '',
      packageName: info.internalName ?? '',
      version: versions.getOrNull(0) ?? '',
      buildNumber: versions.getOrNull(1) ?? '',
      buildSignature: '',
    );
    info.dispose();
    return Future.value(data);
  }
}

extension _GetOrNull<T> on List<T> {
  T? getOrNull(int index) => _checkIndex(index) ? this[index] : null;
  bool _checkIndex(int index) => index >= 0 && index < length;
}
