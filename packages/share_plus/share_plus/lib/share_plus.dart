// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/foundation.dart' show kIsWeb, visibleForTesting;
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:share_plus_linux/share_plus_linux.dart';
import 'package:share_plus_windows/share_plus_windows.dart';
import 'package:cross_file/cross_file.dart';

/// Plugin for summoning a platform share sheet.
class Share {
  /// Disables the platform override in order to use a manually registered
  /// [SharePlatform] for testing purposes.
  /// See https://github.com/flutter/flutter/issues/52267 for more details.
  @visibleForTesting
  static set disableSharePlatformOverride(bool override) {
    _disablePlatformOverride = override;
  }

  static bool _disablePlatformOverride = false;
  static SharePlatform? __platform;

  // This is to manually endorse the Linux plugin until automatic registration
  // of dart plugins is implemented.
  // See https://github.com/flutter/flutter/issues/52267 for more details.
  static SharePlatform get _platform {
    if (__platform == null) {
      if (!_disablePlatformOverride && !kIsWeb) {
        if (Platform.isLinux) {
          __platform = ShareLinux();
        } else if (Platform.isWindows) {
          __platform = ShareWindows();
        }
      }
      __platform ??= SharePlatform.instance;
    }
    return __platform!;
  }

  /// Summons the platform's share sheet to share text.
  ///
  /// Wraps the platform's native share dialog. Can share a text and/or a URL.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// The optional [subject] parameter can be used to populate a subject if the
  /// user chooses to send an email.
  ///
  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads. It has no effect
  /// on non-iPads.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) {
    assert(text.isNotEmpty);
    return _platform.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share multiple files.
  ///
  /// Wraps the platform's native share dialog. Can share a file.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// The optional `sharePositionOrigin` parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads. It has no effect
  /// on non-iPads.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    assert(paths.isNotEmpty);
    assert(paths.every((element) => element.isNotEmpty));
    return _platform.shareFiles(
      paths,
      mimeTypes: mimeTypes,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share multiple files.
  ///
  /// Wraps the platform's native share dialog. Can share a file.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// The optional `sharePositionOrigin` parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads. It has no effect
  /// on non-iPads.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  static Future<void> shareCrossFiles(
    List<XFile> paths, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    assert(paths.isNotEmpty);
    return _platform.shareCrossFiles(
      paths,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
