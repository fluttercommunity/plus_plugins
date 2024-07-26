// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ui';

import 'package:cross_file/cross_file.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../method_channel/method_channel_share.dart';

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

  /// Share uri.
  Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) {
    return _instance.shareUri(
      uri,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Share text with Result.
  Future<ShareResult> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    return await _instance.share(
      text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Share [XFile] objects with Result.
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
  }) async {
    return _instance.shareXFiles(
      files,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
      fileNameOverrides: fileNameOverrides,
    );
  }
}

/// The result of a share to determine what action the
/// user has taken.
///
/// [status] provides an easy way to determine how the
/// share-sheet was handled by the user, while [raw] provides
/// possible access to the action selected.
class ShareResult {
  /// The raw return value from the share.
  ///
  /// Note that an empty string means the share-sheet was
  /// dismissed without any action and the special value
  /// `dev.fluttercommunity.plus/share/unavailable` points
  /// to the current environment not supporting share results.
  final String raw;

  /// The action the user has taken
  final ShareResultStatus status;

  const ShareResult(this.raw, this.status);

  static const unavailable = ShareResult(
    'dev.fluttercommunity.plus/share/unavailable',
    ShareResultStatus.unavailable,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShareResult && other.raw == raw && other.status == status;
  }

  @override
  int get hashCode => raw.hashCode ^ status.hashCode;

  @override
  String toString() {
    return 'ShareResult(raw: $raw, status: $status)';
  }
}

/// How the user handled the share-sheet
enum ShareResultStatus {
  /// The user has selected an action
  success,

  /// The user dismissed the share-sheet
  dismissed,

  /// The platform succeed to share content to user
  /// but the user action can not be determined
  unavailable,
}
