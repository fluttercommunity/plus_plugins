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
import 'package:web/web.dart' as web
    show DOMException, File, FilePropertyBag, Navigator, window;

/// The web implementation of [SharePlatform].
class SharePlusWebPlugin extends SharePlatform {
  final UrlLauncherPlatform urlLauncher;

  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SharePlatform.instance = SharePlusWebPlugin(UrlLauncherPlugin());
  }

  final web.Navigator _navigator;

  /// A constructor that allows tests to override the window object used by the plugin.
  SharePlusWebPlugin(
    this.urlLauncher, {
    @visibleForTesting web.Navigator? debugNavigator,
  }) : _navigator = debugNavigator ?? web.window.navigator;

  @override
  Future<ShareResult> shareUri(
    Uri uri, {
    Rect? sharePositionOrigin,
  }) async {
    final data = ShareData.url(
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
    } on web.DOMException catch (e) {
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
      data = ShareData.textWithTitle(
        title: subject,
        text: text,
      );
    } else {
      data = ShareData.text(
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
    } on web.DOMException catch (e) {
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
  }) async {
    final webFiles = <web.File>[];
    for (final xFile in files) {
      webFiles.add(await _fromXFile(xFile));
    }

    final ShareData data;
    if (text != null && text.isNotEmpty) {
      if (subject != null && subject.isNotEmpty) {
        data = ShareData.filesWithTextAndTitle(
          files: webFiles.toJS,
          text: text,
          title: subject,
        );
      } else {
        data = ShareData.filesWithText(
          files: webFiles.toJS,
          text: text,
        );
      }
    } else if (subject != null && subject.isNotEmpty) {
      data = ShareData.filesWithTitle(
        files: webFiles.toJS,
        title: subject,
      );
    } else {
      data = ShareData.files(
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
    } on web.DOMException catch (e) {
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

  static Future<web.File> _fromXFile(XFile file) async {
    final bytes = await file.readAsBytes();
    return web.File(
      [bytes.buffer.toJS].toJS,
      file.name,
      web.FilePropertyBag()
        ..type = file.mimeType ?? _mimeTypeForPath(file, bytes),
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

extension on web.Navigator {
  /// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/canShare
  external bool canShare(ShareData data);

  /// https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share
  external JSPromise share(ShareData data);
}

extension type ShareData._(JSObject _) implements JSObject {
  external factory ShareData.text({
    String text,
  });

  external factory ShareData.textWithTitle({
    String text,
    String title,
  });

  external factory ShareData.files({
    JSArray<web.File> files,
  });

  external factory ShareData.filesWithText({
    JSArray<web.File> files,
    String text,
  });

  external factory ShareData.filesWithTitle({
    JSArray<web.File> files,
    String title,
  });

  external factory ShareData.filesWithTextAndTitle({
    JSArray<web.File> files,
    String text,
    String title,
  });

  external factory ShareData.url({
    String url,
  });
}
