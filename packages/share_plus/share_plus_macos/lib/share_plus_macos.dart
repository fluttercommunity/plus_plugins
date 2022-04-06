// The share_plus_platform_interface defaults to MethodChannelShare
// as its instance, which is all the macOS implementation needs. This file
// is here to silence warnings when publishing to pub.

/// The Windows implementation of `share_plus`.
library share_plus_macos;

import 'dart:ui';

import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

/// The Windows implementation of SharePlatform.
class ShareMacOS extends SharePlatform {
  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    SharePlatform.instance = ShareMacOS();
  }
}
