import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus_windows/share_plus_windows.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';

void main() {
  test('url encoding is correct', () {
    final mock = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mock;

    ShareWindows().share('foo&bar', subject: 'bar&foo');

    expect(mock.url, 'mailto:?subject=bar%26foo&body=foo%26bar');
  });
}

class MockUrlLauncherPlatform extends UrlLauncherPlatform {
  String? url;

  @override
  LinkDelegate? get linkDelegate => throw UnimplementedError();

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  Future<bool> launch(
    String url, {
    required bool useSafariVC,
    required bool useWebView,
    required bool enableJavaScript,
    required bool enableDomStorage,
    required bool universalLinksOnly,
    required Map<String, String> headers,
    String? webOnlyWindowName,
  }) async {
    this.url = url;
    return true;
  }
}
