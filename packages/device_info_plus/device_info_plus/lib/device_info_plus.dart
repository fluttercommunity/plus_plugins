// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:flutter/foundation.dart';
export 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    show
        AndroidBuildVersion,
        AndroidDeviceInfo,
        BaseDeviceInfo,
        IosDeviceInfo,
        IosUtsname,
        LinuxDeviceInfo,
        MacOsDeviceInfo,
        WindowsDeviceInfo,
        WebBrowserInfo,
        BrowserName;

/// Provides device and operating system information.
class DeviceInfoPlugin {
  /// No work is done when instantiating the plugin. It's safe to call this
  /// repeatedly or in performance-sensitive blocks.
  const DeviceInfoPlugin();

  // This is to manually endorse the Linux plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static DeviceInfoPlatform get _platform {
    return DeviceInfoPlatform.instance;
  }

  /// This information does not change from call to call. Cache it.
  static Future<AndroidDeviceInfo>? _androidDeviceInfoFuture;

  /// Information derived from `android.os.Build`.
  ///
  /// See: https://developer.android.com/reference/android/os/Build.html
  Future<AndroidDeviceInfo> get androidInfo =>
      _androidDeviceInfoFuture ??= _platform.androidInfo();

  /// This information does not change from call to call. Cache it.
  static Future<IosDeviceInfo>? _iosDeviceInfoFuture;

  /// Information derived from `UIDevice`.
  ///
  /// See: https://developer.apple.com/documentation/uikit/uidevice
  Future<IosDeviceInfo> get iosInfo =>
      _iosDeviceInfoFuture ??= _platform.iosInfo();

  /// This information does not change from call to call. Cache it.
  static Future<LinuxDeviceInfo>? _linuxDeviceInfoFuture;

  /// Information derived from `/etc/os-release`.
  ///
  /// See: https://www.freedesktop.org/software/systemd/man/os-release.html
  Future<LinuxDeviceInfo> get linuxInfo =>
      _linuxDeviceInfoFuture ??= _platform.linuxInfo();

  /// This information does not change from call to call. Cache it.
  static Future<WebBrowserInfo>? _webBrowserInfoFuture;

  /// Information derived from `Navigator`.
  Future<WebBrowserInfo> get webBrowserInfo =>
      _webBrowserInfoFuture ??= _platform.webBrowserInfo();

  /// This information does not change from call to call. Cache it.
  static Future<MacOsDeviceInfo>? _macosDeviceInfoFuture;

  /// Returns device information for macos. Information sourced from Sysctl.
  Future<MacOsDeviceInfo> get macOsInfo =>
      _macosDeviceInfoFuture ??= _platform.macosInfo();

  static Future<WindowsDeviceInfo>? _windowsDeviceInfoFuture;

  /// Returns device information for Windows.
  Future<WindowsDeviceInfo> get windowsInfo =>
      _windowsDeviceInfoFuture ??= _platform.windowsInfo()!;

  /// Returns device information for the current platform.
  Future<BaseDeviceInfo> get deviceInfo async {
    if (kIsWeb) {
      return webBrowserInfo;
    } else {
      if (Platform.isAndroid) {
        return androidInfo;
      } else if (Platform.isIOS) {
        return iosInfo;
      } else if (Platform.isLinux) {
        return linuxInfo;
      } else if (Platform.isMacOS) {
        return macOsInfo;
      } else if (Platform.isWindows) {
        return windowsInfo;
      }
    }

    throw UnsupportedError('Unsupported platform');
  }
}
