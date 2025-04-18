import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';

import 'url_launcher_mock.dart';

void main() {
  test('registered instance', () {
    SharePlusLinuxPlugin.registerWith();
    expect(SharePlatform.instance, isA<SharePlusLinuxPlugin>());
  });

  test('url encoding is correct for &', () async {
    final mock = MockUrlLauncherPlatform();

    await SharePlusLinuxPlugin(mock).share(
      ShareParams(text: 'foo&bar', subject: 'bar&foo'),
    );

    expect(mock.url, 'mailto:?subject=bar%26foo&body=foo%26bar');
  });

  // see https://github.com/dart-lang/sdk/issues/43838#issuecomment-823551891
  test('url encoding is correct for spaces', () async {
    final mock = MockUrlLauncherPlatform();

    await SharePlusLinuxPlugin(mock).share(
      ShareParams(text: 'foo bar', subject: 'bar foo'),
    );

    expect(mock.url, 'mailto:?subject=bar%20foo&body=foo%20bar');
  });

  test('can share URI on Linux', () async {
    final mock = MockUrlLauncherPlatform();

    await SharePlusLinuxPlugin(mock).share(
      ShareParams(uri: Uri.parse('http://example.com')),
    );

    expect(mock.url, 'mailto:?body=http%3A%2F%2Fexample.com');
  });
}
