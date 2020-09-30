// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:package_info_plus_windows/package_info_plus_windows.dart';

/// Application metadata. Provides application bundle information on iOS and
/// application package information on Android.
class PackageInfo {
  /// Constructs an instance with the given values for testing. [PackageInfo]
  /// instances constructed this way won't actually reflect any real information
  /// from the platform, just whatever was passed in at construction time.
  ///
  /// See [fromPlatform] for the right API to get a [PackageInfo]
  /// that's actually populated with real data.
  PackageInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
  });

  /// Disables the platform override in order to use a manually registered
  /// [PackageInfoPlatform] for testing purposes.
  /// See https://github.com/flutter/flutter/issues/52267 for more details.
  @visibleForTesting
  static set disablePackageInfoPlatformOverride(bool override) {
    _disablePlatformOverride = override;
  }

  static bool _disablePlatformOverride = false;
  static PackageInfoPlatform __platform;

  // This is to manually endorse the Windows plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static PackageInfoPlatform get _platform {
    __platform ??= Platform.isWindows && !_disablePlatformOverride
        ? PackageInfoWindows()
        : PackageInfoPlatform.instance;
    return __platform;
  }

  static PackageInfo _fromPlatform;

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<PackageInfo> fromPlatform() async {
    if (_fromPlatform != null) {
      return _fromPlatform;
    }

    final platformData = await _platform.getAll();
    _fromPlatform = PackageInfo(
      appName: platformData.appName,
      packageName: platformData.packageName,
      version: platformData.version,
      buildNumber: platformData.buildNumber,
    );
    return _fromPlatform;
  }

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String buildNumber;
}
