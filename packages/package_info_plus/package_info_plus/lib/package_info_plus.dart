// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

export 'src/package_info_plus_linux.dart';
export 'src/package_info_plus_windows.dart'
    if (dart.library.js_interop) 'src/package_info_plus_web.dart';

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
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    this.buildSignature = '',
    this.installerStore,
  });

  static PackageInfo? _fromPlatform;

  /// Retrieves package information from the platform.
  /// The result is cached.
  ///
  /// The [baseUrl] parameter is for web use only and the other platforms will
  /// ignore it.
  ///
  /// ## Web platform
  ///
  /// In a web environment, the package uses the `version.json` file that it is
  /// generated in the build process.
  ///
  /// The package will try to locate this file in 3 ways:
  ///
  ///   * If you provide the optional custom [baseUrl] parameter, it will be
  ///     used as the first option where to search. Example:
  ///
  ///     ```dart
  ///     await PackageInfo.fromPlatform(baseUrl: 'https://cdn.domain.com/with/some/path/');
  ///     ```
  ///
  ///     With this, the package will try to search the file in `https://cdn.domain.com/with/some/path/version.json`
  ///
  ///   * The second option where it will search is the [assetBase] parameter
  ///     that you can pass to the Flutter Web Engine when you initialize it.
  ///
  ///     ```javascript
  ///     _flutter.loader.loadEntrypoint({
  ///         onEntrypointLoaded: async function(engineInitializer) {
  ///           let appRunner = await engineInitializer.initializeEngine({
  ///             assetBase: "https://cdn.domain.com/with/some/path/"
  ///           });
  ///           appRunner.runApp();
  ///         }
  ///     });
  ///     ```
  ///
  ///     For more information about the Flutter Web Engine initialization see here:
  ///     https://docs.flutter.dev/platform-integration/web/initialization#initializing-the-engine
  ///
  ///   * Finally, if none of the previous locations return the `version.json` file,
  ///     the package will use the browser window base URL to resolve its location.
  static Future<PackageInfo> fromPlatform({String? baseUrl}) async {
    if (_fromPlatform != null) {
      return _fromPlatform!;
    }

    final platformData = await PackageInfoPlatform.instance.getAll(
      baseUrl: baseUrl,
    );

    _fromPlatform = PackageInfo(
      appName: platformData.appName,
      packageName: platformData.packageName,
      version: platformData.version,
      buildNumber: platformData.buildNumber,
      buildSignature: platformData.buildSignature,
      installerStore: platformData.installerStore,
    );
    return _fromPlatform!;
  }

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  /// Note, on iOS if an app has no buildNumber specified this property will return version
  /// Docs about CFBundleVersion: https://developer.apple.com/documentation/bundleresources/information_property_list/cfbundleversion
  final String buildNumber;

  /// The build signature. Empty string on iOS, signing key signature (hex) on Android.
  final String buildSignature;

  /// The installer store. Indicates through which store this application was installed.
  final String? installerStore;

  /// Initializes the application metadata with mock values for testing.
  ///
  /// If the singleton instance has been initialized already, it is overwritten.
  @visibleForTesting
  static void setMockInitialValues({
    required String appName,
    required String packageName,
    required String version,
    required String buildNumber,
    required String buildSignature,
    String? installerStore,
  }) {
    _fromPlatform = PackageInfo(
      appName: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
      buildSignature: buildSignature,
      installerStore: installerStore,
    );
  }

  /// Overwrite equals for value equality
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackageInfo &&
          runtimeType == other.runtimeType &&
          appName == other.appName &&
          packageName == other.packageName &&
          version == other.version &&
          buildNumber == other.buildNumber &&
          buildSignature == other.buildSignature &&
          installerStore == other.installerStore;

  /// Overwrite hashCode for value equality
  @override
  int get hashCode =>
      appName.hashCode ^
      packageName.hashCode ^
      version.hashCode ^
      buildNumber.hashCode ^
      buildSignature.hashCode ^
      installerStore.hashCode;

  @override
  String toString() {
    return 'PackageInfo(appName: $appName, buildNumber: $buildNumber, packageName: $packageName, version: $version, buildSignature: $buildSignature, installerStore: $installerStore)';
  }

  Map<String, dynamic> _toMap() {
    return {
      'appName': appName,
      'buildNumber': buildNumber,
      'packageName': packageName,
      'version': version,
      if (buildSignature.isNotEmpty) 'buildSignature': buildSignature,
      if (installerStore?.isNotEmpty ?? false) 'installerStore': installerStore,
    };
  }

  /// Gets a map representation of the [PackageInfo] instance.
  Map<String, dynamic> get data => _toMap();
}
