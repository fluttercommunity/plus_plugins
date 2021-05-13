/// The Windows implementation of `share_plus`.
library share_plus_windows;

import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// The Windows implementation of SharePlatform.
class ShareWindows extends SharePlatform {
  /// Share text.
  @override
  Future<void> share(
    String text, {
    String? subject,
    Rect? sharePositionOrigin,
  }) {
    final queryParameters = {
      if (subject != null) 'subject': subject,
      'body': text,
    };

    final uri = Uri(
      scheme: 'mailto',
      queryParameters: queryParameters,
    );

    return launch(uri.toString());
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
    throw UnimplementedError(
        'shareFiles() has not been implemented on Windows.');
  }
}
