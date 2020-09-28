// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

export 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    show
        AndroidBuildVersion,
        AndroidDeviceInfo,
        IosDeviceInfo,
        IosUtsname,
        LinuxDeviceInfo,
        WebBrowserInfo;

/// Provides device and operating system information.
class DeviceInfoPlugin {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  DeviceInfoPlugin();

  /// This information does not change from call to call. Cache it.
  AndroidDeviceInfo _cachedAndroidDeviceInfo;

  /// Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  Future<AndroidDeviceInfo> get androidInfo async =>
      _cachedAndroidDeviceInfo ??=
          await DeviceInfoPlatform.instance.androidInfo();

  /// This information does not change from call to call. Cache it.
  IosDeviceInfo _cachedIosDeviceInfo;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  Future<IosDeviceInfo> get iosInfo async =>
      _cachedIosDeviceInfo ??= await DeviceInfoPlatform.instance.iosInfo();

  /// This information does not change from call to call. Cache it.
  LinuxDeviceInfo _cachedLinuxDeviceInfo;

  /// Information derived from `/etc/os-release`.
  ///
  /// See: https://www.freedesktop.org/software/systemd/man/os-release.html
  Future<LinuxDeviceInfo> get linuxInfo async =>
      _cachedLinuxDeviceInfo ??= await DeviceInfoPlatform.instance.linuxInfo();

  /// This information does not change from call to call. Cache it.
  WebBrowserInfo _cachedWebBrowserInfo;

  /// Information derived from `Navigator`.
  Future<WebBrowserInfo> get webBrowserInfo async => _cachedWebBrowserInfo ??=
      await DeviceInfoPlatform.instance.webBrowserInfo();
}
