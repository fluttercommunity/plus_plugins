import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

void main() {
  test('registered instance', () {
    SharePlusLinuxPlugin.registerWith();
    expect(SharePlatform.instance, isA<SharePlusLinuxPlugin>());
  });
  test('url encoding is correct for &', () async {
    final mock = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mock;

    await SharePlusLinuxPlugin().share('foo&bar', subject: 'bar&foo');

    expect(mock.url, 'mailto:?subject=bar%26foo&body=foo%26bar');
  });

  // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
  test('url encoding is correct for spaces', () async {
    final mock = MockUrlLauncherPlatform();
    UrlLauncherPlatform.instance = mock;

    await SharePlusLinuxPlugin().share('foo bar', subject: 'bar foo');

    expect(mock.url, 'mailto:?subject=bar%20foo&body=foo%20bar');
  });

  test('throws when url_launcher can\'t launch uri', () async {
    final mock = MockUrlLauncherPlatform();
    mock.canLaunchMockValue = false;
    UrlLauncherPlatform.instance = mock;

    expect(() async => await SharePlusLinuxPlugin().share('foo bar'),
        throwsException);
  });
}

class MockUrlLauncherPlatform extends UrlLauncherPlatform {
  String? url;
  bool canLaunchMockValue = true;

  @override
  LinkDelegate? get linkDelegate => throw UnimplementedError();

  @override
  Future<bool> canLaunch(String url) async {
    return canLaunchMockValue;
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
    if (!canLaunchMockValue) {
      throw Exception();
    }
    return true;
  }
}
