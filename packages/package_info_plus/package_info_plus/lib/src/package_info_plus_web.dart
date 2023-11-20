import 'dart:convert';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:web/helpers.dart' as web;

/// The web implementation of [PackageInfoPlatform].
///
/// This class implements the `package:package_info_plus` functionality for the web.
class PackageInfoPlusWebPlugin extends PackageInfoPlatform {
  final Client? _client;

  /// Create plugin with http client.
  PackageInfoPlusWebPlugin([this._client]);

  /// Registers this class as the default instance of [PackageInfoPlatform].
  static void registerWith(Registrar registrar) {
    PackageInfoPlatform.instance = PackageInfoPlusWebPlugin();
  }

  /// Get version.json full url.
  Uri versionJsonUrl(String baseUrl, int cacheBuster) {
    final baseUri = Uri.parse(baseUrl);
    final regExp = RegExp(r'[^/]+\.html.*');
    final String originPath =
        '${baseUri._origin}${baseUri.path.replaceAll(regExp, '')}';

    // Clean uri: remove fragment and query
    Uri uri = Uri.parse(originPath).removeFragment().replace(query: '');

    // In http/s, if the last part has no file extension and not trailing slash,
    // we can safely remove it since it's not considered as a folder
    if (uri.path.length > 1 &&
        !uri.path.endsWith('/') &&
        (uri.isScheme('http') || uri.isScheme('https'))) {
      uri = uri.replace(path: uri.path.substring(0, uri.path.lastIndexOf('/')));
    }

    // Clean uri: remove empty path segments
    final List<String> segments = [...uri.pathSegments]
      ..removeWhere((element) => element == '');

    // Add file and cachebuster query
    return uri.replace(
        query: 'cachebuster=$cacheBuster',
        pathSegments: [...segments, 'version.json']);
  }

  @override
  Future<PackageInfoData> getAll() async {
    final cacheBuster = DateTime.now().millisecondsSinceEpoch;
    final url = versionJsonUrl(web.window.document.baseURI, cacheBuster);
    final response = _client == null ? await get(url) : await _client.get(url);
    final versionMap = _getVersionMap(response);

    return PackageInfoData(
      appName: versionMap['app_name'] ?? '',
      version: versionMap['version'] ?? '',
      buildNumber: versionMap['build_number'] ?? '',
      packageName: versionMap['package_name'] ?? '',
      // will remain empty on web
      buildSignature: '',
    );
  }

  Map<String, dynamic> _getVersionMap(Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return <String, dynamic>{};
      }
    } else {
      return <String, dynamic>{};
    }
  }
}

extension _UriOrigin on Uri {
  /// Get origin.
  ///
  /// This is different from [Uri.origin] because that has checks to prevent
  /// non-http/https use-cases.
  String get _origin {
    if (isScheme('chrome-extension')) {
      return '$scheme://$host';
    }
    return origin;
  }
}
