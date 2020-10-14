import 'dart:html' as html;
import 'dart:ui';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:meta/meta.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

/// The web implementation of [SharePlatform].
class SharePlugin extends SharePlatform {
  /// Registers this class as the default instance of [SharePlatform].
  static void registerWith(Registrar registrar) {
    SharePlatform.instance = SharePlatform();
  }

  final _navigator;

  /// A constructor that allows tests to override the window object used by the plugin.
  SharePlugin({@visibleForTesting html.Navigator debugNavigator})
      : _navigator = debugNavigator ?? html.window.navigator;

  Future<void> share(
    String text, {
    String subject,
    Rect sharePositionOrigin,
  }) async {
    try {
      await _navigator.share({'title': subject, 'text': text});
    } catch (e) {
      //Navigator is not available or the webPage is not served on https
      final uri = Uri.encodeFull('mailto:?subject=$subject&body=$text');
      return launch(uri);
    }
  }

  @override
  Future<void> shareFiles(List<String> paths,
      {List<String> mimeTypes,
      String subject,
      String text,
      Rect sharePositionOrigin}) {
    throw UnimplementedError('shareFiles() has not been implemented on Web.');
  }
}
