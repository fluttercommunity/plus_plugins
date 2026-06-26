// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:package_info_plus/package_info_plus.dart';

/// Compile-time package metadata, provided at build time with `--dart-define`:
///
/// ```sh
/// flutter build web \
///   --dart-define=PACKAGE_INFO_PLUS_VERSION=1.2.3 \
///   --dart-define=PACKAGE_INFO_PLUS_BUILD_NUMBER=45
/// ```
const _version = String.fromEnvironment('PACKAGE_INFO_PLUS_VERSION');
const _buildNumber = String.fromEnvironment('PACKAGE_INFO_PLUS_BUILD_NUMBER');
const _appName = String.fromEnvironment('PACKAGE_INFO_PLUS_APP_NAME');
const _packageName = String.fromEnvironment('PACKAGE_INFO_PLUS_PACKAGE_NAME');

/// Tool-provided fallbacks, recognized so that apps need no configuration at
/// all once their build front-end injects the version itself:
///
/// * `FLUTTER_BUILD_NAME` / `FLUTTER_BUILD_NUMBER` — proposed in
///   flutter/flutter#187935 (injected by flutter_tools from the pubspec
///   `version`, like `FLUTTER_APP_FLAVOR` already is).
/// * `dart.package.version` — companion proposal for the `dart` CLI
///   (dart-lang/sdk#38855); carries the verbatim pubspec `version`,
///   including any `+buildNumber` suffix.
///
/// The explicit `PACKAGE_INFO_PLUS_*` defines take precedence over both.
const _flutterBuildName = String.fromEnvironment('FLUTTER_BUILD_NAME');
const _flutterBuildNumber = String.fromEnvironment('FLUTTER_BUILD_NUMBER');
const _dartPackageVersion = String.fromEnvironment('dart.package.version');

/// Holds the compile-time package info and enforces, at compile time, that a
/// version was provided on web builds.
///
/// The `assert` runs during constant evaluation: importing this library into a
/// **web** build that does not pass `--dart-define=PACKAGE_INFO_PLUS_VERSION`
/// is a compile error. Native builds are unaffected (`kIsWeb` is `false`
/// there), because they read the real version from the installed binary via
/// [PackageInfo.fromPlatform].
class _CompileTimePackageInfo {
  const _CompileTimePackageInfo()
    : assert(
        !kIsWeb ||
            _version != '' ||
            _flutterBuildName != '' ||
            _dartPackageVersion != '',
        'PACKAGE_INFO_PLUS_VERSION must be provided via --dart-define on web '
        'builds. On the web there is no reliable runtime source for the '
        'version of the *running* bundle (version.json is fetched from the '
        'server and reflects the deployed version, not the executing one). '
        'Pass --dart-define=PACKAGE_INFO_PLUS_VERSION=<your version> '
        '(and optionally PACKAGE_INFO_PLUS_BUILD_NUMBER / _APP_NAME / '
        '_PACKAGE_NAME) to your web build.',
      );

  String get version {
    if (_version != '') return _version;
    if (_flutterBuildName != '') return _flutterBuildName;
    return _dartPackageVersion.split('+').first;
  }

  String get buildNumber {
    if (_buildNumber != '') return _buildNumber;
    if (_flutterBuildNumber != '') return _flutterBuildNumber;
    if (_dartPackageVersion.contains('+')) {
      return _dartPackageVersion.split('+').last;
    }
    return '';
  }

  String get appName => _appName;
  String get packageName => _packageName;
}

/// Opt-in accessor for the **running** application's [PackageInfo].
///
/// Import this library explicitly (it is intentionally not exported by
/// `package_info_plus.dart`) when you need a version you can trust on the web —
/// for example to display it to the user or to gate outdated clients.
///
/// Behaviour per platform:
///
/// * **Web** — returns a [PackageInfo] built from the compile-time
///   `PACKAGE_INFO_PLUS_*` defines. These are embedded in the running bundle,
///   so they cannot diverge from it the way the server-fetched `version.json`
///   used by [PackageInfo.fromPlatform] can. A web build that omits
///   `PACKAGE_INFO_PLUS_VERSION` **fails to compile** — a misleading version
///   can never ship silently.
/// * **All other platforms** — delegates to [PackageInfo.fromPlatform], which
///   reads the installed binary's metadata and is already reliable. The defines
///   are not required there.
abstract final class PackageInfoEnvironment {
  /// The running application's [PackageInfo]. See [PackageInfoEnvironment].
  static Future<PackageInfo> get packageInfo async {
    if (kIsWeb) {
      const env = _CompileTimePackageInfo();
      return PackageInfo(
        appName: env.appName,
        packageName: env.packageName,
        version: env.version,
        buildNumber: env.buildNumber,
      );
    }
    return PackageInfo.fromPlatform();
  }
}
