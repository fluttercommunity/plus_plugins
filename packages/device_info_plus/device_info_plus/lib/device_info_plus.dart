// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:device_info_plus/src/api/device_info_request/android_info_request.dart';
import 'package:device_info_plus/src/api/device_info_request/ios_info_request.dart';
import 'package:device_info_plus/src/api/device_info_request/linux_info_request.dart';
import 'package:device_info_plus/src/api/device_info_request/macos_info_request.dart';
import 'package:device_info_plus/src/api/device_info_request/web_info_request.dart';
import 'package:device_info_plus/src/api/device_info_request/windows_info_request.dart';
import 'package:device_info_plus/src/api/device_provider.dart';
import 'package:device_info_plus/src/model/macos_device_info.dart';
import 'package:device_info_plus/src/model/web_browser_info.dart';
import 'package:device_info_plus/src/model/windows_device_info.dart';
import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';

import 'src/model/android_device_info.dart';
import 'src/model/ios_device_info.dart';
import 'src/model/linux_device_info.dart';

export 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart'
    show BaseDeviceInfo;

export 'src/model/android_device_info.dart';
export 'src/model/ios_device_info.dart';
export 'src/model/linux_device_info.dart';
export 'src/model/macos_device_info.dart';
export 'src/model/web_browser_info.dart';
export 'src/model/windows_device_info.dart';

export 'src/device_info_plus_linux.dart';
export 'src/device_info_plus_windows.dart'
    if (dart.library.html) 'src/device_info_plus_web.dart';

sealed class Device {}

class Android implements Device {
  Future<AndroidDeviceInfo> getInfo(dynamic platform) async {
    final AndroidInfo androidInfo = AndroidInfo(platform: platform);
    return await androidInfo.info();
  }
}

class IOS implements Device {
  Future<IosDeviceInfo> getInfo(dynamic platform) async {
    final IosInfo isoInfo = IosInfo(platform: platform);
    return await isoInfo.info();
  }
}

class Linux implements Device {
  Future<LinuxDeviceInfo> getInfo(dynamic platform) async {
    final LinuxInfo linuxInfo = LinuxInfo(platform: platform);
    return await linuxInfo.info();
  }
}

class Web implements Device {
  Future<WebBrowserInfo> getInfo(dynamic platform) async {
    final WebInfo webInfo = WebInfo(platform: platform);
    return await webInfo.info();
  }
}

class MacOS implements Device {
  Future<MacOsDeviceInfo> getInfo(dynamic platform) async {
    final MacOsInfo macOsInfo = MacOsInfo(platform: platform);
    return await macOsInfo.info();
  }
}

class Windows implements Device {
  Future<WindowsDeviceInfo> getInfo(dynamic platform) {
    final WindowsInfo windowsInfo = WindowsInfo(platform: platform);
    return windowsInfo.info();
  }
}

/// Provides device and operating system information.
class DeviceInfoPlugin {
  Device? device;

  DeviceInfoPlugin() {
    device = DeviceProvider.getDevice();
  }
  BaseDeviceInfo? _cachedDeviceInfo;

  // This is to manually endorse the Linux plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static DeviceInfoPlatform get _platform {
    return DeviceInfoPlatform.instance;
  }

  /// Returns device information for the current platform.
  Future<BaseDeviceInfo?> getInfo() async {
    switch (device!) {
      case Android():
        _cachedDeviceInfo ??= await Android().getInfo(_platform);
        break;
      case IOS():
        _cachedDeviceInfo ??= await IOS().getInfo(_platform);
        break;
      case Linux():
        _cachedDeviceInfo ??= await Linux().getInfo(_platform);
        break;
      case Web():
        _cachedDeviceInfo ??= await Web().getInfo(_platform);
        break;
      case MacOS():
        _cachedDeviceInfo ??= await MacOS().getInfo(_platform);
        break;
      case Windows():
        _cachedDeviceInfo ??= await Windows().getInfo(_platform);
        break;
    }
    return _cachedDeviceInfo;
  }
}
