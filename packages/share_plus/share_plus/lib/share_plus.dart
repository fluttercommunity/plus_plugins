// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:meta/meta.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

export 'package:share_plus_platform_interface/share_plus_platform_interface.dart'
    show
        ShareResult,
        ShareResultStatus,
        XFile,
        ShareParams,
        CupertinoActivityType;

export 'src/share_plus_linux.dart';
export 'src/share_plus_windows.dart'
    if (dart.library.js_interop) 'src/share_plus_web.dart';

class SharePlus {
  /// Use [SharePlus.instance] to access the [share] method.
  SharePlus._(this._platform);

  /// Platform interface
  final SharePlatform _platform;

  /// The default instance of [SharePlus].
  static final SharePlus instance = SharePlus._(SharePlatform.instance);

  /// Create a custom instance of [SharePlus].
  /// Use this constructor for testing purposes only.
  @visibleForTesting
  factory SharePlus.custom(SharePlatform platform) => SharePlus._(platform);

  /// Summons the platform's share sheet to share context.
  ///
  /// Wraps the platform's native share dialog. Can share a text and/or a URL.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// When no native share dialog is available,
  /// it will fall back to using mailto to share the content as email.
  ///
  /// Returns [ShareResult] when the action completes.
  ///
  /// * [ShareResult.success] when the user selected a share action.
  /// * [ShareResult.dismissed] when the user dismissed the share sheet.
  /// * [ShareResult.unavailable] when the share result is not available.
  ///
  /// Providing result is only supported on Android, iOS and macOS.
  ///
  /// To avoid deadlocks on Android,
  /// any new call to [share] when there is a call pending,
  /// will cause the previous call to return a [ShareResult.unavailable].
  ///
  /// Because IOS, Android and macOS provide different feedback on share-sheet
  /// interaction, a result on IOS will be more specific than on Android or macOS.
  /// While on IOS the selected action can inform its caller that it was completed
  /// or dismissed midway (_actions are free to return whatever they want_),
  /// Android and macOS only record if the user selected an action or outright
  /// dismissed the share-sheet. It is not guaranteed that the user actually shared
  /// something.
  ///
  /// Will gracefully fall back to the non result variant if not implemented
  /// for the current environment and return [ShareResult.unavailable].
  ///
  /// See [ShareParams] for more information on what can be shared.
  /// Throws [ArgumentError] if [ShareParams] are invalid.
  ///
  /// Throws other types of exceptions if the share method fails.
  Future<ShareResult> share(ShareParams params) async {
    if (params.uri == null &&
        (params.files == null || params.files!.isEmpty) &&
        params.text == null) {
      throw ArgumentError(
        'At least one of uri, files or text must be provided',
      );
    }

    if (params.uri != null && params.text != null) {
      throw ArgumentError('uri and text cannot be provided at the same time');
    }

    if (params.text != null && params.text!.isEmpty) {
      throw ArgumentError('text provided, but cannot be empty');
    }

    if (params.files != null && params.files!.isEmpty) {
      throw ArgumentError('files provided, but cannot be empty');
    }

    if (params.fileNameOverrides != null &&
        (params.files == null ||
            params.files!.length != params.fileNameOverrides!.length)) {
      throw ArgumentError(
        'fileNameOverrides must have the same length as files.',
      );
    }

    return _platform.share(params);
  }
}

@Deprecated('Use SharePlus instead')
class Share {
  /// Whether to fall back to downloading files if [shareXFiles] fails on web.
  /// This parameter is only used when using the [Share] class.
  /// If you want to use this parameter with the [SharePlus] class,
  /// use [ShareParams.downloadFallbackEnabled] instead as it takes preference.
  @Deprecated('Use ShareParams.downloadFallbackEnabled instead')
  static bool downloadFallbackEnabled = true;

  /// Summons the platform's share sheet to share uri.
  ///
  /// Wraps the platform's native share dialog. Can share a URL.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS. [shareUri] will trigger the iOS system to fetch the html page
  /// (if available), and the website icon will be extracted and displayed on
  /// the iOS share sheet.
  ///
  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// May throw [PlatformException]
  /// from [MethodChannel].
  ///
  /// See documentation about [ShareResult] on [share] method.
  @Deprecated('Use SharePlus.instance.share() instead')
  static Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) async {
    return SharePlus.instance.share(
      ShareParams(
        uri: uri,
        sharePositionOrigin: sharePositionOrigin,
        downloadFallbackEnabled: downloadFallbackEnabled,
      ),
    );
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
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  ///
  /// [ShareResult] provides feedback on how the user
  /// interacted with the share-sheet.
  ///
  /// To avoid deadlocks on Android,
  /// any new call to [share] when there is a call pending,
  /// will cause the previous call to return a [ShareResult.unavailable].
  ///
  /// Because IOS, Android and macOS provide different feedback on share-sheet
  /// interaction, a result on IOS will be more specific than on Android or macOS.
  /// While on IOS the selected action can inform its caller that it was completed
  /// or dismissed midway (_actions are free to return whatever they want_),
  /// Android and macOS only record if the user selected an action or outright
  /// dismissed the share-sheet. It is not guaranteed that the user actually shared
  /// something.
  ///
  /// Providing result is only supported on Android, iOS and macOS.
  ///
  /// Will gracefully fall back to the non result variant if not implemented
  /// for the current environment and return [ShareResult.unavailable].
  @Deprecated('Use SharePlus.instance.share() instead')
  static Future<ShareResult> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    assert(text.isNotEmpty);
    return SharePlus.instance.share(
      ShareParams(
        text: text,
        subject: subject,
        sharePositionOrigin: sharePositionOrigin,
        downloadFallbackEnabled: downloadFallbackEnabled,
      ),
    );
  }

  /// Summons the platform's share sheet to share multiple files.
  ///
  /// Wraps the platform's native share dialog. Can share a file.
  /// It uses the `ACTION_SEND` Intent on Android and `UIActivityViewController`
  /// on iOS.
  ///
  /// Android supports all natively available MIME types (wildcards like image/*
  /// are also supported) and it's considered best practice to avoid mixing
  /// unrelated file types (eg. image/jpg & application/pdf). If MIME types are
  /// mixed the plugin attempts to find the lowest common denominator. Even
  /// if MIME types are supplied the receiving app decides if those are used
  /// or handled.
  /// On iOS image/jpg, image/jpeg and image/png are handled as images, while
  /// every other MIME type is considered a normal file.
  ///
  /// The optional [sharePositionOrigin] parameter can be used to specify a global
  /// origin rect for the share sheet to popover from on iPads and Macs. It has no effect
  /// on other devices.
  ///
  /// The optional parameter [fileNameOverrides] can be used to override the names of shared files
  /// When set, the list length must match the number of [files] to share.
  /// This is useful when sharing files that were created by [`XFile.fromData`](https://github.com/flutter/packages/blob/754de1918a339270b70971b6841cf1e04dd71050/packages/cross_file/lib/src/types/io.dart#L43),
  /// because name property will be ignored by  [`cross_file`](https://pub.dev/packages/cross_file) on all platforms except on web.
  ///
  /// May throw [PlatformException] or [FormatException]
  /// from [MethodChannel].
  ///
  /// See documentation about [ShareResult] on [share] method.
  @Deprecated('Use SharePlus.instance.share() instead')
  static Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
  }) async {
    assert(files.isNotEmpty);
    return SharePlus.instance.share(
      ShareParams(
        files: files,
        subject: subject,
        text: text,
        sharePositionOrigin: sharePositionOrigin,
        fileNameOverrides: fileNameOverrides,
        downloadFallbackEnabled: downloadFallbackEnabled,
      ),
    );
  }
}
