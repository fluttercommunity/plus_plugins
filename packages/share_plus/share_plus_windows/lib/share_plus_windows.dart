/// The Windows implementation of `share_plus`.
library share_plus_windows;

import 'dart:ui';

import 'package:share_plus_windows/src/version_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

/// The fallback Windows implementation of [SharePlatform], for older Windows versions.
///
class ShareWindows extends SharePlatform {
  /// If the modern Share UI i.e. `DataTransferManager` is not available, then use this Dart class instead of platform specific implementation.
  ///
  static void registerWith() {
    if (!VersionHelper.instance.isWindows10RS5OrGreater) {
      SharePlatform.instance = ShareWindows();
    }
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
      query: queryParameters.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&'),
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Unable to share on windows');
    }
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
