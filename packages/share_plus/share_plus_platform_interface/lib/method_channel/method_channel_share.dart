// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:mime/mime.dart' show lookupMimeType;
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// Plugin for summoning a platform share sheet.
class MethodChannelShare extends SharePlatform {
  /// [MethodChannel] used to communicate with the platform side.
  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/share');

  /// Summons the platform's share sheet to share text.
  @override
  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) {
    return shareV2(
      ShareMode.text,
      ReturnMode.none,
      text: text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share multiple files.
  @override
  Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    return shareV2(
      ShareMode.files,
      ReturnMode.none,
      text: text,
      subject: subject,
      paths: paths,
      mimeTypes: mimeTypes,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share text and returns the result.
  @override
  Future<ShareResult> shareWithResult(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    return shareV2(
      ShareMode.text,
      ReturnMode.shareResult,
      text: text,
      subject: subject,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Summons the platform's share sheet to share multiple files and returns the result.
  @override
  Future<ShareResult> shareFilesWithResult(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    return shareV2(
      ShareMode.files,
      ReturnMode.shareResult,
      text: text,
      subject: subject,
      paths: paths,
      mimeTypes: mimeTypes,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  @override
  Future<ShareResult> shareV2(
    ShareMode shareMode,
    ReturnMode retMode, {
    String? subject,
    String? text,
    List<String>? paths,
    List<String>? mimeTypes,
    Rect? sharePositionOrigin,
  }) async {
    final params = <String, dynamic>{};

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }

    switch (shareMode) {
      case ShareMode.text:
        assert(text != null && text.isNotEmpty);
        params['text'] = text;
        params['subject'] = subject;
        switch (retMode) {
          case ReturnMode.none:
            await channel.invokeMethod('share', params);
            return _resultEmpty;
          case ReturnMode.shareResult:
            final result =
                await channel.invokeMethod<String>('shareWithResult', params) ??
                    'dev.fluttercommunity.plus/share/unavailable';
            return ShareResult(result, _statusFromResult(result));
        }
      case ShareMode.files:
        assert(paths != null && paths.isNotEmpty);
        assert(paths!.every((element) => element.isNotEmpty));
        params['paths'] = paths;
        params['mimeTypes'] = mimeTypes ??
            paths!.map((String path) => _mimeTypeForPath(path)).toList();
        if (subject != null) params['subject'] = subject;
        if (text != null) params['text'] = text;
        switch (retMode) {
          case ReturnMode.none:
            await channel.invokeMethod('shareFiles', params);
            return _resultEmpty;
          case ReturnMode.shareResult:
            final result = await channel.invokeMethod<String>(
                    'shareFilesWithResult', params) ??
                'dev.fluttercommunity.plus/share/unavailable';
            return ShareResult(result, _statusFromResult(result));
        }
    }
  }

  static String _mimeTypeForPath(String path) {
    return lookupMimeType(path) ?? 'application/octet-stream';
  }

  static ShareResultStatus _statusFromResult(String result) {
    switch (result) {
      case '':
        return ShareResultStatus.dismissed;
      case 'dev.fluttercommunity.plus/share/unavailable':
        return ShareResultStatus.unavailable;
      default:
        return ShareResultStatus.success;
    }
  }
}

/// Returned if the status should be ignored
const _resultEmpty = ShareResult(
  'dev.fluttercommunity.plus/share/empty',
  ShareResultStatus.empty,
);
