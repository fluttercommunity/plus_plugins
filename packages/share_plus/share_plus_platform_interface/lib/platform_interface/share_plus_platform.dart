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
  /// Can be provided with [uri] when [airDrop] is [ShareAirDropAs.url]:
  /// Messages, Mail, and other text destinations receive this string, while
  /// AirDrop still receives the URL.
  ///
  /// Can be used together with [files]. On iOS that string is a caption for
  /// text and multimedia destinations (Messages, Mail, Notes, and other
  /// share extensions). File destinations (Save to Files, AirDrop, Copy,
  /// Print, Books, Camera Roll, Markup as PDF) and the sheet header do not
  /// receive it. Android puts it in EXTRA_TEXT beside the file.
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
  /// origin rect to anchor the share sheet to a widget user interacts with on iPads and Macs.
  /// It has no effect on other devices.
  ///
  /// If this parameter not provided on iPads the popover anchors to the center of the screen
  /// instead of throwing. Providing an accurate rect is still recommended for better UX.
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
  /// Can be used with [text] when [airDrop] is [ShareAirDropAs.url].
  ///
  /// * Supported platforms: iOS, Android
  ///   Falls back to sharing the URI as text on other platforms.
  final Uri? uri;

  /// Share multiple files, can be used in combination with [text].
  ///
  /// On iOS, [text] goes to text and multimedia destinations. Save to Files,
  /// AirDrop, Copy, Print, Books, Camera Roll, Markup as PDF, and the sheet
  /// header stay file-only. Unknown activity types receive [text].
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

  /// Exclude services on iOS and macOS that you think are not suitable for your content.
  ///
  /// * Supported platforms: iOS, macOS
  ///   Parameter ignored on other platforms.
  final List<CupertinoActivityType>? excludedCupertinoActivities;

  /// How AirDrop should deliver [uri] on iOS.
  ///
  /// * [ShareAirDropAs.inherit] keeps the current URI share (raw `NSURL`,
  ///   Safari / page preview on the sheet).
  /// * [ShareAirDropAs.url] wraps the URI like a text share so the host app
  ///   icon stays in the header. AirDrop receives the URL. Messages, Mail,
  ///   and other destinations receive [text] when it is set.
  /// * [ShareAirDropAs.text] sends the URI string as plain text (Notes).
  ///
  /// Android has no AirDrop. [uri] + [title] already go out as EXTRA_TEXT /
  /// EXTRA_TITLE (Nearby Share equivalent). This parameter is ignored there.
  ///
  /// * Supported platforms: iOS
  ///   Parameter ignored on other platforms.
  final ShareAirDropAs airDrop;

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
    this.excludedCupertinoActivities,
    this.airDrop = ShareAirDropAs.inherit,
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

/// Represents iOS-supported share activity types, such as AirDrop, Messages,
/// Mail, and others.
///
/// This enum is used to identify specific activity types in the iOS share sheet,
/// especially when certain types should be excluded from the share options.
///
/// See also:
/// [UIActivity.ActivityType](https://developer.apple.com/documentation/uikit/uiactivity/activitytype)
/// How iOS AirDrop should deliver a shared [ShareParams.uri].
enum ShareAirDropAs {
  /// Keep the current URI-share behaviour (raw URL item).
  inherit,

  /// Deliver the URI as a URL (opens the link instead of Notes).
  url,

  /// Deliver the URI string as plain text.
  text,
}

enum CupertinoActivityType {
  postToFacebook,
  postToTwitter,
  postToWeibo,
  message,
  mail,
  print,
  copyToPasteboard,
  assignToContact,
  saveToCameraRoll,
  addToReadingList,
  postToFlickr,
  postToVimeo,
  postToTencentWeibo,
  airDrop,
  openInIBooks,
  markupAsPDF,
  sharePlay,
  collaborationInviteWithLink,
  collaborationCopyLink,
  addToHomeScreen;

  String get value {
    return toString().split('.').last;
  }
}
