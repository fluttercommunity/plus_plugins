import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';
import 'package:http/http.dart' as http;

import 'package_info_plus_web_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  // ignore: constant_identifier_names
  const VERSION_JSON = {
    'app_name': 'package_info_example',
    'build_number': '1',
    'package_name': 'io.flutter.plugins.packageinfoexample',
    'version': '1.0',
    'build_signature': '',
  };

  late PackageInfoPlugin plugin;
  late MockClient client;

  setUp(() {
    client = MockClient();
    plugin = PackageInfoPlugin(client);
  });

  group(
    'Package Info Web',
    () {
      test(
        'Get correct values when response status is 200',
        () async {
          when(client.get(any)).thenAnswer(
            (_) => Future.value(
              http.Response(jsonEncode(VERSION_JSON), 200),
            ),
          );

          final versionMap = await plugin.getAll();

          expect(versionMap.appName, VERSION_JSON['app_name']);
          expect(versionMap.version, VERSION_JSON['version']);
          expect(versionMap.buildNumber, VERSION_JSON['build_number']);
          expect(versionMap.packageName, VERSION_JSON['package_name']);
          expect(versionMap.buildSignature, VERSION_JSON['build_signature']);
        },
      );

      test(
        'Get empty values when response status is not 200',
        () async {
          when(client.get(any)).thenAnswer(
            (_) => Future.value(
              http.Response('', 404),
            ),
          );

          final versionMap = await plugin.getAll();

          expect(versionMap.appName, isEmpty);
          expect(versionMap.buildNumber, isEmpty);
          expect(versionMap.packageName, isEmpty);
          expect(versionMap.version, isEmpty);
          expect(versionMap.buildSignature, isEmpty);
        },
      );

      test(
        'Get correct versionJsonUrl for http and https',
        () {
          expect(
            plugin.versionJsonUrl('https://example.com/#/my-page', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/a/b/c/#/my-page', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/a/b/c/#/my-page', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/?hello_world=true#/my-page', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/a/b/c/?hello_world=true#/my-page', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/a/b/c?hello_world=true#/my-page', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
        },
      );

      test('Get correct versionJsonUrl for chrome-extension', () {
        expect(
          plugin.versionJsonUrl('chrome-extension://abcdefgh', 1),
          Uri.parse('chrome-extension://abcdefgh/version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl('chrome-extension://abcdefgh/a/b/c', 1),
          Uri.parse(
              'chrome-extension://abcdefgh/a/b/c/version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl('chrome-extension://abcdefgh/#my-page', 1),
          Uri.parse('chrome-extension://abcdefgh/version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl(
              'chrome-extension://abcdefgh/a/b/c/#my-page', 1),
          Uri.parse(
              'chrome-extension://abcdefgh/a/b/c/version.json?cachebuster=1'),
        );
      });
    },
  );
}
