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

  Future<ShareResult> share(ShareParams params) async {
    return _instance.share(params);
  }
}

class ShareParams {
  /// The text to share
  ///
  /// Cannot be provided at the same time as [uri],
  /// as the share method will use one or the other.
  ///
  /// Can be used together with [files],
  /// but it depends on the receiving app if they support
  /// loading files and text from a share action.
  /// Some apps only support one or the other.
  ///
  /// * Supported platforms: All
  final String? text;

  /// Used as share sheet title where supported
  ///
  /// Provided to Android Intent.createChooser as the title,
  /// as well as, EXTRA_TITLE Intent extra.
  ///
  /// Provided to web Navigator Share API as title.
  ///
  /// * Supported platforms: All
  final String? title;

  /// Used as email subject where supported (e.g. EXTRA_SUBJECT on Android)
  ///
  /// When using the email fallback, this will be the subject of the email.
  ///
  /// * Supported platforms: All
  final String? subject;

  /// Preview thumbnail
  ///
  /// TODO: https://github.com/fluttercommunity/plus_plugins/pull/3372
  ///
  /// * Supported platforms: Android
  ///   Parameter ignored on other platforms.
  final XFile? previewThumbnail;

  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// * Supported platforms: iPad and Mac
  ///   Parameter ignored on other platforms.
  final Rect? sharePositionOrigin;

  /// Share a URI.
  ///
  /// On iOS, it will trigger the iOS system to fetch the html page
  /// (if available), and the website icon will be extracted and displayed on
  /// the iOS share sheet.
  ///
  /// On other platforms it behaves like sharing text.
  ///
  /// Cannot be used in combination with [text].
  ///
  /// * Supported platforms: iOS, Android
  ///   Falls back to sharing the URI as text on other platforms.
  final Uri? uri;

  /// Share multiple files, can be used in combination with [text]
  ///
  /// Android supports all natively available MIME types (wildcards like image/*
  /// are also supported) and it's considered best practice to avoid mixing
  /// unrelated file types (eg. image/jpg & application/pdf). If MIME types are
  /// mixed the plugin attempts to find the lowest common denominator. Even
  /// if MIME types are supplied the receiving app decides if those are used
  /// or handled.
  ///
  /// On iOS image/jpg, image/jpeg and image/png are handled as images, while
  /// every other MIME type is considered a normal file.
  ///
  ///
  /// * Supported platforms: Android, iOS, Web, recent macOS and Windows versions
  ///   Throws an [UnimplementedError] on other platforms.
  final List<XFile>? files;

  /// Override the names of shared files.
  ///
  /// When set, the list length must match the number of [files] to share.
  /// This is useful when sharing files that were created by [`XFile.fromData`](https://github.com/flutter/packages/blob/754de1918a339270b70971b6841cf1e04dd71050/packages/cross_file/lib/src/types/io.dart#L43),
  /// because name property will be ignored by  [`cross_file`](https://pub.dev/packages/cross_file) on all platforms except on web.
  ///
  /// * Supported platforms: Same as [files]
  ///   Ignored on platforms that don't support [files].
  final List<String>? fileNameOverrides;

  /// Whether to fall back to downloading files if [share] fails on web.
  ///
  /// * Supported platforms: Web
  ///   Parameter ignored on other platforms.
  final bool downloadFallbackEnabled;

  /// Whether to fall back to sending an email if [share] fails on web.
  ///
  /// * Supported platforms: Web
  ///   Parameter ignored on other platforms.
  final bool mailToFallbackEnabled;

  ShareParams({
    this.text,
    this.subject,
    this.title,
    this.previewThumbnail,
    this.sharePositionOrigin,
    this.uri,
    this.files,
    this.fileNameOverrides,
    this.downloadFallbackEnabled = true,
    this.mailToFallbackEnabled = true,
  });
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
