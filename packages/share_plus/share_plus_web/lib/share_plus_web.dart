import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:meta/meta.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

/// The web implementation of [SharePlatform].
class SharePlusPlugin extends SharePlatform {
  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SharePlatform.instance = SharePlusPlugin();
  }

  // ignore: prefer_typing_uninitialized_variables
  final _navigator;

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

      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
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
  }) {
    throw UnimplementedError('shareFiles() has not been implemented on Web.');
  }
}
