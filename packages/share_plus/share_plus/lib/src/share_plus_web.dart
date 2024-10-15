import 'dart:developer' as developer;
import 'dart:js_interop';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:meta/meta.dart';
import 'package:mime/mime.dart' show lookupMimeType;
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:web/web.dart';

/// The web implementation of [SharePlatform].
class SharePlusWebPlugin extends SharePlatform {
  final UrlLauncherPlatform urlLauncher;

  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SharePlatform.instance = SharePlusWebPlugin(UrlLauncherPlugin());
  }

  final Navigator _navigator;

  /// A constructor that allows tests to override the window object used by the plugin.
  SharePlusWebPlugin(
    this.urlLauncher, {
    @visibleForTesting Navigator? debugNavigator,
  }) : _navigator = debugNavigator ?? window.navigator;

  @override
  Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) async {
    final data = ShareData(
      url: uri.toString(),
    );

    final bool canShare;
    try {
      canShare = _navigator.canShare(data);
    } on NoSuchMethodError catch (e) {
      developer.log(
        'Share API is not supported in this User Agent.',
        error: e,
      );

      throw Exception('Navigator.canShare() is unavailable');
    }

    if (!canShare) {
      throw Exception('Navigator.canShare() is false');
    }

    try {
      await _navigator.share(data).toDart;
    } on DOMException catch (e) {
      if (e.name case 'AbortError') {
        return _resultDismissed;
      }

      developer.log(
        'Failed to share uri',
        error: '${e.name}: ${e.message}',
      );

      throw Exception('Navigator.share() failed: ${e.message}');
    }

    return ShareResult.unavailable;
  }

  @override
  Future<ShareResult> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    final ShareData data;
    if (subject != null && subject.isNotEmpty) {
      data = ShareData(
        title: subject,
        text: text,
      );
    } else {
      data = ShareData(
        text: text,
      );
    }

    final bool canShare;
    try {
      canShare = _navigator.canShare(data);
    } on NoSuchMethodError catch (e) {
      developer.log(
        'Share API is not supported in this User Agent.',
        error: e,
      );

      // Navigator is not available or the webPage is not served on https
      final queryParameters = {
        if (subject != null) 'subject': subject,
        'body': text,
      };

      // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
      final uri = Uri(
        scheme: 'mailto',
        query: queryParameters.entries
            .map((e) =>
                '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
            .join('&'),
      );

      final launchResult = await urlLauncher.launchUrl(
        uri.toString(),
        const LaunchOptions(),
      );
      if (!launchResult) {
        throw Exception('Failed to launch $uri');
      }

      return ShareResult.unavailable;
    }

    if (!canShare) {
      throw Exception('Navigator.canShare() is false');
    }

    try {
      await _navigator.share(data).toDart;

      // actions is success, but can't get the action name
      return ShareResult.unavailable;
    } on DOMException catch (e) {
      if (e.name case 'AbortError') {
        return _resultDismissed;
      }

      developer.log(
        'Failed to share text',
        error: '${e.name}: ${e.message}',
      );

      throw Exception('Navigator.share() failed: ${e.message}');
    }
  }

  /// Share [XFile] objects.
  ///
  /// Remarks for the web implementation:
  /// This uses the [Web Share API](https://web.dev/web-share/) if it's
  /// available. This builds on the
  /// [`cross_file`](https://pub.dev/packages/cross_file) package.
  @override
  Future<ShareResult> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    List<String>? fileNameOverrides,
  }) async {
    assert(
        fileNameOverrides == null || files.length == fileNameOverrides.length);
    final webFiles = <File>[];
    for (var index = 0; index < files.length; index++) {
      final xFile = files[index];
      final filename = fileNameOverrides?.elementAt(index);
      webFiles.add(await _fromXFile(xFile, nameOverride: filename));
    }

    final ShareData data;
    if (text != null && text.isNotEmpty) {
      if (subject != null && subject.isNotEmpty) {
        data = ShareData(
          files: webFiles.toJS,
          text: text,
          title: subject,
        );
      } else {
        data = ShareData(
          files: webFiles.toJS,
          text: text,
        );
      }
    } else if (subject != null && subject.isNotEmpty) {
      data = ShareData(
        files: webFiles.toJS,
        title: subject,
      );
    } else {
      data = ShareData(
        files: webFiles.toJS,
      );
    }

    final bool canShare;
    try {
      canShare = _navigator.canShare(data);
    } on NoSuchMethodError catch (e) {
      developer.log(
        'Share API is not supported in this User Agent.',
        error: e,
      );

      throw Exception('Navigator.canShare() is unavailable');
    }

    if (!canShare) {
      throw Exception('Navigator.canShare() is false');
    }

    try {
      await _navigator.share(data).toDart;

      // actions is success, but can't get the action name
      return ShareResult.unavailable;
    } on DOMException catch (e) {
      if (e.name case 'AbortError') {
        return _resultDismissed;
      }

      developer.log(
        'Failed to share files',
        error: '${e.name}: ${e.message}',
      );

      throw Exception('Navigator.share() failed: ${e.message}');
    }
  }

  static Future<File> _fromXFile(XFile file, {String? nameOverride}) async {
    final bytes = await file.readAsBytes();
    return File(
      [bytes.buffer.toJS].toJS,
      nameOverride ?? file.name,
      FilePropertyBag()..type = file.mimeType ?? _mimeTypeForPath(file, bytes),
    );
  }

  static String _mimeTypeForPath(XFile file, Uint8List bytes) {
    return lookupMimeType(file.name, headerBytes: bytes) ??
        'application/octet-stream';
  }
}

const _resultDismissed = ShareResult(
  '',
  ShareResultStatus.dismissed,
);
