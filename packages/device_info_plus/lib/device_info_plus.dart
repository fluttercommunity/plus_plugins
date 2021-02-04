// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:device_info_plus_linux/device_info_plus_linux.dart';

export 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    show
        AndroidBuildVersion,
        AndroidDeviceInfo,
        IosDeviceInfo,
        IosUtsname,
        LinuxDeviceInfo,
        MacOsDeviceInfo,
        WebBrowserInfo;

/// Provides device and operating system information.
class DeviceInfoPlugin {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  DeviceInfoPlugin();

  /// Disables the platform override in order to use a manually registered
  /// [DeviceInfoPlatform] for testing purposes.
  /// See https://github.com/flutter/flutter/issues/52267 for more details.
  @visibleForTesting
  static set disableDeviceInfoPlatformOverride(bool override) {
    _disablePlatformOverride = override;
  }

  static bool _disablePlatformOverride = false;
  static DeviceInfoPlatform __platform;

  // This is to manually endorse the Linux plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static DeviceInfoPlatform get _platform {
    __platform ??= !kIsWeb && Platform.isLinux && !_disablePlatformOverride
        ? DeviceInfoLinux()
        : DeviceInfoPlatform.instance;
    return __platform;
  }

  /// This information does not change from call to call. Cache it.
  AndroidDeviceInfo _cachedAndroidDeviceInfo;

  /// Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  Future<AndroidDeviceInfo> get androidInfo async =>
      _cachedAndroidDeviceInfo ??= await _platform.androidInfo();

  /// This information does not change from call to call. Cache it.
  IosDeviceInfo _cachedIosDeviceInfo;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  Future<IosDeviceInfo> get iosInfo async =>
      _cachedIosDeviceInfo ??= await _platform.iosInfo();

  /// This information does not change from call to call. Cache it.
  LinuxDeviceInfo _cachedLinuxDeviceInfo;

  /// Information derived from `/etc/os-release`.
  ///
  /// See: https://www.freedesktop.org/software/systemd/man/os-release.html
  Future<LinuxDeviceInfo> get linuxInfo async =>
      _cachedLinuxDeviceInfo ??= await _platform.linuxInfo();

  /// This information does not change from call to call. Cache it.
  WebBrowserInfo _cachedWebBrowserInfo;

  /// Information derived from `Navigator`.
  Future<WebBrowserInfo> get webBrowserInfo async =>
      _cachedWebBrowserInfo ??= await _platform.webBrowserInfo();

  /// This information does not change from call to call. Cache it.
  MacOsDeviceInfo _cachedMacosDeviceInfo;

  /// Returns device information for macos. Information sourced from Sysctl.
  Future<MacOsDeviceInfo> get macOsInfo async =>
      _cachedMacosDeviceInfo ??= await _platform.macosInfo();
}
