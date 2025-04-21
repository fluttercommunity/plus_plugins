/// The Linux implementation of `share_plus`.
library;

import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher_linux/url_launcher_linux.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// The Linux implementation of SharePlatform.
class SharePlusLinuxPlugin extends SharePlatform {
  SharePlusLinuxPlugin(this.urlLauncher);

  final UrlLauncherPlatform urlLauncher;

  /// Register this dart class as the platform implementation for linux
  static void registerWith() {
    SharePlatform.instance = SharePlusLinuxPlugin(UrlLauncherLinux());
  }

  @override
  Future<ShareResult> share(ShareParams params) async {
    if (params.files?.isNotEmpty == true) {
      throw UnimplementedError('Sharing files not supported on Linux');
    }

    final queryParameters = {
      if (params.subject != null) 'subject': params.subject,
      if (params.uri != null) 'body': params.uri.toString(),
      if (params.text != null) 'body': params.text,
    };

    // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
    final uri = Uri(
      scheme: 'mailto',
      query: queryParameters.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value ?? '')}')
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
}
