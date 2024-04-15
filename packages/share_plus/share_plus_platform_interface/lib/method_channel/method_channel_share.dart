// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

// Keep dart:ui for retrocompatiblity with Flutter <3.3.0
// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart' show visibleForTesting;
import 'package:mime/mime.dart' show extensionFromMime, lookupMimeType;
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Plugin for summoning a platform share sheet.
class MethodChannelShare extends SharePlatform {
  /// [MethodChannel] used to communicate with the platform side.
  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('dev.fluttercommunity.plus/share');

  @override
  Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) async {
    final params = <String, dynamic>{'uri': uri.toString()};

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }

    final result = await channel.invokeMethod<String>('shareUri', params) ??
        'dev.fluttercommunity.plus/share/unavailable';

    return ShareResult(result, _statusFromResult(result));
  }

  /// Summons the platform's share sheet to share text.
  @override
  Future<ShareResult> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    assert(text.isNotEmpty);
    final params = <String, dynamic>{
      'text': text,
      'subject': subject,
    };

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }

    final result = await channel.invokeMethod<String>('share', params) ??
        'dev.fluttercommunity.plus/share/unavailable';

    return ShareResult(result, _statusFromResult(result));
  }

  /// Summons the platform's share sheet to share multiple files.
  @override
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    assert(files.isNotEmpty);

    final filesWithPath = await _getFiles(files);
    assert(filesWithPath.every((element) => element.path.isNotEmpty));

    final mimeTypes = filesWithPath
        .map((e) => e.mimeType ?? _mimeTypeForPath(e.path))
        .toList();

    final paths = filesWithPath.map((e) => e.path).toList();
    assert(paths.length == mimeTypes.length);
    assert(mimeTypes.every((element) => element.isNotEmpty));

    final params = <String, dynamic>{
      'paths': paths,
      'mimeTypes': mimeTypes,
    };

    if (subject != null) params['subject'] = subject;
    if (text != null) params['text'] = text;

    if (sharePositionOrigin != null) {
      params['originX'] = sharePositionOrigin.left;
      params['originY'] = sharePositionOrigin.top;
      params['originWidth'] = sharePositionOrigin.width;
      params['originHeight'] = sharePositionOrigin.height;
    }

    final result = await channel.invokeMethod<String>('shareFiles', params) ??
        'dev.fluttercommunity.plus/share/unavailable';

    return ShareResult(result, _statusFromResult(result));
  }

  /// Ensure that a file is readable from the file system. Will create file on-demand under TemporaryDiectory and return the temporary file otherwise.
  ///
  /// if file doesn't contain path,
  /// then make new file in TemporaryDirectory and return with path
  /// the system will automatically delete files in this
  /// TemporaryDirectory as disk space is needed elsewhere on the device
  Future<XFile> _getFile(XFile file, {String? tempRoot}) async {
    if (file.path.isNotEmpty) {
      return file;
    } else {
      tempRoot ??= (await getTemporaryDirectory()).path;
      var extension = extensionFromMime(file.mimeType ?? 'octet-stream');

      // TODO: As soon as the mime package fixes the image/jpe issue, remove this line immediately
      // Reference: https://github.com/dart-lang/mime/issues/55
      extension = extension == "jpe" ? "jpeg" : extension;

      //By having a UUID v4 folder wrapping the file
      //This path generation algorithm will not only minimize the risk of name collision but also ensure that the filename
      //is not ridiculously long such that some platforms might not show the extension but ellipses
      //which the user needs
      //
      //More importantly it allows us to use real filenames when available
      final tempSubfolderPath = "$tempRoot/${const Uuid().v4()}";
      await Directory(tempSubfolderPath).create(recursive: true);

      //Per Issue [#1548](https://github.com/fluttercommunity/plus_plugins/issues/1548): attempt to use XFile.name when available
      final filename = file.name.isNotEmpty // If filename exists
              ||
              lookupMimeType(file.name) !=
                  null //If the filename has a valid extension
          ? file.name
          : "${const Uuid().v1().substring(10)}.$extension";

      final path = "$tempSubfolderPath/$filename";

      //Write the file to FS
      await File(path).writeAsBytes(await file.readAsBytes());

      return XFile(path);
    }
  }

  /// A wrapper of [MethodChannelShare._getFile] for multiple files.
  Future<List<XFile>> _getFiles(List<XFile> files) async =>
      await Future.wait(files.map((entry) => _getFile(entry)));

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
