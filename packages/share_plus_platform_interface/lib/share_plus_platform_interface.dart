// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel/method_channel_share.dart';

/// The interface that implementations of `share_plus` must implement.
class SharePlatform extends PlatformInterface {
  /// Constructs a SharePlatform.
  SharePlatform() : super(token: _token);

  static final Object _token = Object();

  static SharePlatform _instance = MethodChannelShare();

  /// The default instance of [SharePlatform] to use.
  ///
  /// Defaults to [MethodChannelShare].
  static SharePlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [SharePlatform] when they register themselves.
  static set instance(SharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Share text.
  Future<void> share(
    String text, {
    String subject,
    Rect sharePositionOrigin,
  }) {
    return _instance.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Share files.
  Future<void> shareFiles(
    List<String> paths, {
    List<String> mimeTypes,
    String subject,
    String text,
    Rect sharePositionOrigin,
  }) {
    return _instance.shareFiles(
      paths,
      mimeTypes: mimeTypes,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }
}
