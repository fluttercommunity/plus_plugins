import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web';

import 'package:clock/clock.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:http/http.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';
import 'package:web/web.dart' as web;

/// Get the current service worker version.
/// This is used to get the application version that matches the current
/// service worker (even if there is a newer version available).
///
/// If no version is found, we fallback to the cachebuster
/// which will load the latest version of the file.
///
/// To get this working, you will need to add the following code to your
/// index.html:
/// ```javascript
///     // This line should already exist
///     var serviceWorkerVersion = {{SERVICE_WORKER_VERSION}};
///     // This line should be added
///     window.serviceWorkerVersion = serviceWorkerVersion;
/// ```
@JS('serviceWorkerVersion')
external String? get _serviceWorkerVersion;

/// The web implementation of [PackageInfoPlatform].
///
/// This class implements the `package:package_info_plus` functionality for the web.
class PackageInfoPlusWebPlugin extends PackageInfoPlatform {
  final Client? _client;
  final AssetManager _assetManager;

  /// Create plugin with http client and asset manager for testing purposes.
  PackageInfoPlusWebPlugin([this._client, AssetManager? assetManagerMock])
      : _assetManager = assetManagerMock ?? assetManager;

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

    // Add file, serviceWorkerVersion and cachebuster query
    return uri.replace(
        query: _serviceWorkerVersion != null
            ? 'serviceWorkerVersion=$_serviceWorkerVersion'
            : 'cachebuster=$cacheBuster',
        pathSegments: [...segments, 'version.json']);
  }

  @override
  Future<PackageInfoData> getAll({String? baseUrl}) async {
    final int cacheBuster = clock.now().millisecondsSinceEpoch;
    final Map<String, dynamic> versionMap =
        await _getVersionMap(baseUrl, cacheBuster) ??
            await _getVersionMap(_assetManager.baseUrl, cacheBuster) ??
            await _getVersionMap(web.window.document.baseURI, cacheBuster) ??
            {};

    return PackageInfoData(
      appName: versionMap['app_name'] ?? '',
      version: versionMap['version'] ?? '',
      buildNumber: versionMap['build_number'] ?? '',
      packageName: versionMap['package_name'] ?? '',
      // will remain empty on web
      buildSignature: '',
    );
  }

  Future<Map<String, dynamic>?> _getVersionMap(
    String? baseUrl,
    int cacheBuster,
  ) async {
    if (baseUrl?.isNotEmpty == true) {
      final Uri url = versionJsonUrl(baseUrl!, cacheBuster);
      final Response response = await _getResponse(url);

      return _decodeVersionMap(response);
    }

    return null;
  }

  Future<Response> _getResponse(Uri uri) async {
    return _client == null ? await get(uri) : await _client.get(uri);
  }

  Map<String, dynamic>? _decodeVersionMap(Response response) {
    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (_) {
        return null;
      }
    } else {
      return null;
    }
  }
}

extension _AssetManager on AssetManager {
  /// Get the base URL configured in the Flutter Web Engine initialization
  ///
  /// The AssetManager has the base URL as private ([AssetManager._baseUrl] property),
  /// so we need to do some little hack to get it. If AssetManager adds in some
  /// moment a public API to get the base URL, this extension can be replaced by that API.
  ///
  /// @see https://docs.flutter.dev/platform-integration/web/initialization#initializing-the-engine
  String get baseUrl {
    return getAssetUrl('').replaceAll('$assetsDir/', '');
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
    } else if (isScheme('file')) {
      return '$scheme://';
    }
    return origin;
  }
}
