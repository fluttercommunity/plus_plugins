/// The Windows implementation of `package_info_plus`.
library package_info_plus_windows;

import 'dart:io';

import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

import 'file_version_info.dart';

/// The Windows implementation of [PackageInfoPlatform].
///
/// This class provides Windows-specific functionality for retrieving package info,
/// such as application name, package name, version, and build number.
class PackageInfoPlusWindowsPlugin extends PackageInfoPlatform {
  /// Registers this class as the platform implementation for Windows.
  static void registerWith() {
    PackageInfoPlatform.instance = PackageInfoPlusWindowsPlugin();
  }

  /// Returns a [PackageInfoData] object containing information about the app.
  ///
  /// This method retrieves the app name, package name, version, and build number
  /// from the executable file's version information.
  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async {
    try {
      String resolvedExecutable = Platform.resolvedExecutable;

      // Workaround for UNC path issues on Windows.
      if (resolvedExecutable.startsWith(r"UNC\")) {
        resolvedExecutable = resolvedExecutable.replaceFirst(r"UNC\", r"\\");
      }

      final info = FileVersionInfo(resolvedExecutable);
      final versions = info.productVersion.split('+');
      final data = PackageInfoData(
        appName: info.productName,
        packageName: info.internalName,
        version: versions.getOrNull(0) ?? '',
        buildNumber: versions.getOrNull(1) ?? '',
        buildSignature: '', // Will remain empty on Windows
      );
      info.dispose();
      return Future.value(data);
    } catch (e) {
      // Handle exceptions, e.g., logging or rethrowing
      return Future.error('Failed to retrieve package info: $e');
    }
  }
}

extension _GetOrNull<T> on List<T> {
  /// Returns the element at the specified index or null if the index is out of bounds.
  T? getOrNull(int index) => _checkIndex(index) ? this[index] : null;

  bool _checkIndex(int index) => index >= 0 && index < length;
}
