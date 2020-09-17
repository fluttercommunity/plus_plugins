// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:package_info_plus_platform_interface/package_info.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
export 'package:package_info_plus_platform_interface/package_info.dart';

/// Application metadata. Provides application bundle information on iOS and
/// application package information on Android.
class PackageInfoPlugin {
  static PackageInfo _fromPlatform;

  /// Retrieves package information from the platform.
  /// The result is cached.
  static Future<PackageInfo> fromPlatform() async {
    if (_fromPlatform != null) {
      return _fromPlatform;
    }

    _fromPlatform = await PackageInfoPlatform.instance.getAll();
    return _fromPlatform;
  }
}
