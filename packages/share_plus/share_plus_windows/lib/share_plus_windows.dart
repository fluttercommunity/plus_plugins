/// The Windows implementation of `share_plus`.
library share_plus_windows;

import 'dart:io';
import 'dart:ui';

import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';


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

  /// Share file with specific app, skipping Browser launch
  @override
  Future<void> shareFileWithApp(String path, ShareWithAppWindows appName)async {

    await Process.run(shareWithAppWindowsCmd[appName]!,[path.toString()],runInShell: true);
   // throw UnimplementedError('shareFileWith() has not been implemented on Windows.');
  }

  /// Share files.
  @override
  Future<void> shareFiles(
    List<String> paths, {
    List<String>? mimeTypes,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) {
    throw UnimplementedError('shareFiles() has not been implemented on Windows.');
  }

  Map<ShareWithAppWindows, String> shareWithAppWindowsCmd = {
    ShareWithAppWindows.BY_DEFAULT_APP: "explorer",
    ShareWithAppWindows.MSPAINT: "mspaint",
    ShareWithAppWindows.NOTEPAD: "notepad",
    ShareWithAppWindows.NOTEPAD_PLUS_PLUS: "start notepad++.exe",
    ShareWithAppWindows.PHOTOSHOP: "start Photoshop",
    ShareWithAppWindows.EDGE: "start msedge",
    ShareWithAppWindows.CHROME: "chrome",
  };

}
