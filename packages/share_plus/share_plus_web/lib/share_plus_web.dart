import 'dart:html' as html;
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mime/mime.dart' show lookupMimeType;
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

/// The web implementation of [SharePlatform].
class SharePlusPlugin extends SharePlatform {
  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SharePlatform.instance = SharePlusPlugin();
  }

  final html.Navigator _navigator;

  /// A constructor that allows tests to override the window object used by the plugin.
  SharePlusPlugin({@visibleForTesting html.Navigator? debugNavigator})
      : _navigator = debugNavigator ?? html.window.navigator;

  /// Share text
  @override
  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    try {
      await _navigator.share({'title': subject, 'text': text});
    } on NoSuchMethodError catch (_) {
      //Navigator is not available or the webPage is not served on https
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

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw Exception('Unable to share on web');
      }
    }
  }

  /// Share files
  @override
  Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    final files = <XFile>[];
    for (var i = 0; i < paths.length; i++) {
      files.add(XFile(paths[i], mimeType: mimeTypes?[i]));
    }
    return shareXFiles(
      files,
      subject: subject,
      text: text,
      sharePositionOrigin: sharePositionOrigin,
    );
  }

  /// Share [XFile] objects.
  ///
  /// Remarks for the web implementation:
  /// This uses the [Web Share API](https://web.dev/web-share/) if it's
  /// available. Otherwise it falls back to downloading the shared files.
  /// See [Can I Use - Web Share API](https://caniuse.com/web-share) to
  /// understand which browsers are supported. This builds on the
  /// [`cross_file`](https://pub.dev/packages/cross_file) package.
  @override
  Future<void> shareXFiles(
    List<XFile> files, {
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    // See https://developer.mozilla.org/en-US/docs/Web/API/Navigator/share

    final webFiles = <html.File>[];
    for (final xFile in files) {
      webFiles.add(await _fromXFile(xFile));
    }
    try {
      await _navigator.share({
        if (subject?.isNotEmpty ?? false) 'title': subject,
        if (text?.isNotEmpty ?? false) 'text': text,
        if (webFiles.isNotEmpty) 'files': webFiles,
      });
    } on NoSuchMethodError catch (exception, stackTrace) {
      FlutterError.onError?.call(FlutterErrorDetails(
        exception: exception,
        stack: stackTrace,
        context: DiagnosticsNode.message('while trying to share file(s)'),
        library: 'share_plus_web',
        informationCollector: () => [
          DiagnosticsNode.message(
            'The web share API is not available on the current browser. '
            'Falling back to downloading the files. '
            'Subject and text are discarded if given.',
          ),
        ],
      ));
      // fall back to save the file, if file sharing is not available
      for (final xFile in files) {
        // on web the path is ignored
        await xFile.saveTo('path');
      }
    } catch (exception, stackTrace) {
      // Ideally we would be able to catch JSs NotAllowedError and TypeError,
      // but we can't, so here we are.
      // Reasons for failures are listed here:
      // https://w3c.github.io/web-share/
      FlutterError.onError?.call(FlutterErrorDetails(
        exception: exception,
        stack: stackTrace,
        context: DiagnosticsNode.message('while trying to share a file(s)'),
        library: 'share_plus_web',
        informationCollector: () => [
          DiagnosticsNode.message(
            'This failure can be caused by various problems: '
            'A file type is being blocked due to security considerations. '
            'Files is empty or the browser does not support it. '
            'See https://w3c.github.io/web-share/ for further information. '
            'Falling back to downloading the files. '
            'Subject and text are discarded if given.',
          ),
        ],
      ));
      // fall back to save the file, if file sharing is not available
      for (final xFile in files) {
        // on web the path is ignored
        await xFile.saveTo('path');
      }
    }
  }

  static Future<html.File> _fromXFile(XFile file) async {
    final bytes = await file.readAsBytes();
    return html.File(
      [ByteData.sublistView(bytes)],
      file.name,
      {
        'type': file.mimeType ?? _mimeTypeForPath(file, bytes),
      },
    );
  }

  static String _mimeTypeForPath(XFile file, Uint8List bytes) {
    return lookupMimeType(file.name, headerBytes: bytes) ??
        'application/octet-stream';
  }
}
