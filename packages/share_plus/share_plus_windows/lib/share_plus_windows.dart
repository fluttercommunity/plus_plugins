/// The Windows implementation of `share_plus`.
library share_plus_windows;

import 'dart:io';
import 'dart:ui';

import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

export 'package:share_plus_platform_interface/share_plus_platform_interface.dart' show ShareResult, ShareResultStatus, ShareWithApp;

/// The Windows implementation of SharePlatform.
class ShareWindows extends SharePlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    SharePlatform.instance = ShareWindows();
  }

  /// Share text.
  @override
  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) async {
    final queryParameters = {
      if (subject != null) 'subject': subject,
      'body': text,
    };

    // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
    final uri = Uri(
      scheme: 'mailto',
      query: queryParameters.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&'),
    );

    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      throw Exception('Unable to share on windows');
    }
  }

  /// Share files.
  /// [paths] pass only 1 file for Windows platform
  /// [text] [subject] share text NOT supported for Windows platform
  @override
  Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
    ShareWithApp? appName,
  }) async {
    try {
      if (appName == null) {
        appName == ShareWithApp.BY_DEFAULT_APP;
      }
      await Process.run(
        ShareWithAppCmd[appName]!,
        [paths.first.toString()],
        runInShell: true,
      );
    } catch (e) {
      throw Exception('Unable to share on windows');
    }
  }

  Map<ShareWithApp, String> ShareWithAppCmd = {
    ShareWithApp.BY_DEFAULT_APP: "explorer",
    ShareWithApp.MS_PAINT: "mspaint",
    ShareWithApp.NOTEPAD: "notepad",
    ShareWithApp.NOTEPAD_PLUS_PLUS: "start notepad++.exe",
    ShareWithApp.PHOTOSHOP: "start Photoshop",
    ShareWithApp.EDGE: "start msedge",
    ShareWithApp.CHROME: "chrome",
  };
}
