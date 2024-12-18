import 'dart:developer' as developer;
import 'dart:js_interop';
import 'dart:typed_data';

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
  Future<ShareResult> share(ShareParams params) async {
    // Prepare share data params
    final ShareData data = await prepareData(params);

    // Check if can share
    final bool canShare;
    try {
      canShare = _navigator.canShare(data);
    } on NoSuchMethodError catch (e) {
      developer.log(
        'Share API is not supported in this User Agent.',
        error: e,
      );

      return _fallback(params, 'Navigator.canShare() is unavailable');
    }

    if (!canShare) {
      return _fallback(params, 'Navigator.canShare() is false');
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

      return _fallback(params, 'Navigator.share() failed: ${e.message}');
    }

    return ShareResult.unavailable;
  }

  Future<ShareData> prepareData(ShareParams params) async {
    // Prepare share data params
    final uri = params.uri?.toString();
    final text = params.text;
    final title = params.subject ?? params.title;
    ShareData data;

    // Prepare files
    final webFiles = <File>[];
    if (params.files != null) {
      final files = params.files;
      if (files != null && files.isNotEmpty == true) {
        for (var index = 0; index < files.length; index++) {
          final xFile = files[index];
          final filename = params.fileNameOverrides?.elementAt(index);
          webFiles.add(await _fromXFile(xFile, nameOverride: filename));
        }
      }
    }

    if (uri == null && text == null && webFiles.isEmpty) {
      throw ArgumentError(
        'At least one of uri, text, or files must be provided',
      );
    }

    if (uri != null && text != null) {
      throw ArgumentError('Only one of uri or text can be provided');
    }

    if (uri != null) {
      data = ShareData(
        url: uri,
      );
    } else if (webFiles.isNotEmpty && text != null && title != null) {
      data = ShareData(
        text: text,
        title: title,
        files: webFiles.toJS,
      );
    } else if (webFiles.isNotEmpty && text != null) {
      data = ShareData(
        text: text,
        files: webFiles.toJS,
      );
    } else if (webFiles.isNotEmpty && title != null) {
      data = ShareData(
        title: title,
        files: webFiles.toJS,
      );
    } else if (webFiles.isNotEmpty) {
      data = ShareData(
        files: webFiles.toJS,
      );
    } else if (text != null && title != null) {
      data = ShareData(
        text: text,
        title: title,
      );
    } else {
      data = ShareData(
        text: text!,
      );
    }

    return data;
  }

  /// Fallback method to when sharing on web fails.
  /// If [ShareParams.downloadFallbackEnabled] is true, it will attempt to download the files.
  /// If [ShareParams.mailToFallbackEnabled] is true, it will attempt to share text as email.
  /// Otherwise, it will throw an exception.
  Future<ShareResult> _fallback(ShareParams params, String error) async {
    developer.log(error);

    final subject = params.subject;
    final text = params.text ?? params.uri?.toString() ?? '';
    final files = params.files;
    final fileNameOverrides = params.fileNameOverrides;
    final downloadFallbackEnabled = params.downloadFallbackEnabled;
    final mailToFallbackEnabled = params.mailToFallbackEnabled;

    if (files != null && files.isNotEmpty) {
      if (downloadFallbackEnabled) {
        return _download(files, fileNameOverrides);
      } else {
        throw Exception(error);
      }
    }

    if (!mailToFallbackEnabled) {
      throw Exception(error);
    }

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
      throw Exception(error);
    }

    return ShareResult.unavailable;
  }

  Future<ShareResult> _download(
    List<XFile> files,
    List<String>? fileNameOverrides,
  ) async {
    developer.log('Download files as fallback');
    try {
      for (final (index, file) in files.indexed) {
        final bytes = await file.readAsBytes();

        final anchor = document.createElement('a') as HTMLAnchorElement
          ..href = Uri.dataFromBytes(bytes).toString()
          ..style.display = 'none'
          ..download = fileNameOverrides?.elementAt(index) ?? file.name;
        document.body!.children.add(anchor);
        anchor.click();
        anchor.remove();
      }

      return ShareResult.unavailable;
    } catch (error) {
      developer.log('Failed to download files', error: error);
      throw Exception('Failed to to download files: $error');
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
