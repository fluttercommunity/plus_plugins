@TestOn('browser')
library;

import 'dart:convert';
import 'dart:ui_web' as ui_web;

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus/src/package_info_plus_web.dart';

import 'package_info_plus_test.dart' as common_tests;
import 'package_info_plus_web_test.mocks.dart';

@GenerateMocks([http.Client, ui_web.AssetManager])
void main() {
  common_tests.main();

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: constant_identifier_names
  const VERSION_JSON = {
    'app_name': 'package_info_example',
    'build_number': '1',
    'package_name': 'io.flutter.plugins.packageinfoexample',
    'version': '1.0',
    'installerStore': null,
    'build_signature': '',
  };

  // ignore: constant_identifier_names
  const VERSION_2_JSON = {
    'app_name': 'package_info_example',
    'build_number': '2',
    'package_name': 'io.flutter.plugins.packageinfoexample',
    'version': '2.0',
    'installerStore': null,
    'build_signature': '',
  };

  late PackageInfoPlusWebPlugin plugin;
  late MockClient client;
  late MockAssetManager assetManagerMock;

  group(
    'Package Info Web',
    () {
      setUp(() {
        client = MockClient();
        plugin = PackageInfoPlusWebPlugin(client);
      });

      testWidgets(
        'Get correct values when response status is 200',
        (tester) async {
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

      testWidgets(
        'Get empty values when response status is not 200',
        (tester) async {
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

      testWidgets(
        'Get correct values when using a custom base URL',
        (tester) async {
          const String baseUrl = 'https://www.example.com/';
          final DateTime now = DateTime.now();
          final Clock fakeClock = Clock(() => now);

          await withClock(fakeClock, () async {
            final int cache = now.millisecondsSinceEpoch;

            when(client.get(
              Uri.parse('${baseUrl}version.json?cachebuster=$cache'),
            )).thenAnswer(
              (_) => Future.value(
                http.Response(jsonEncode(VERSION_JSON), 200),
              ),
            );

            final versionMap = await plugin.getAll(baseUrl: baseUrl);

            expect(versionMap.appName, VERSION_JSON['app_name']);
            expect(versionMap.version, VERSION_JSON['version']);
            expect(versionMap.buildNumber, VERSION_JSON['build_number']);
            expect(versionMap.packageName, VERSION_JSON['package_name']);
            expect(versionMap.buildSignature, VERSION_JSON['build_signature']);
          });
        },
      );

      testWidgets(
        'Get correct versionJsonUrl for http and https',
        (tester) async {
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
            // 'c' here is to be considered as a page, not a folder
            plugin.versionJsonUrl(
                'https://example.com/a/b/c?hello_world=true#/my-page', 1),
            Uri.parse('https://example.com/a/b/version.json?cachebuster=1'),
          );
        },
      );

      testWidgets(
        'Get correct versionJsonUrl for urls to html files',
        (tester) async {
          expect(
            plugin.versionJsonUrl('https://example.com', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/index.html', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/index.html#/my-page', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/index.html?hello_world=true/#/my-page', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl('https://example.com/a/b/c/wrapper.html', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/my-special-file.html', 1),
            Uri.parse('https://example.com/version.json?cachebuster=1'),
          );
          expect(
            plugin.versionJsonUrl(
                'https://example.com/a/b/c/my-special-file.html', 1),
            Uri.parse('https://example.com/a/b/c/version.json?cachebuster=1'),
          );
        },
      );

      testWidgets('Get correct versionJsonUrl for chrome-extension',
          (tester) async {
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

      testWidgets('Get correct versionJsonUrl for file', (tester) async {
        expect(
          plugin.versionJsonUrl('file://abcdefgh', 1),
          Uri.parse('file:///version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl('file://abcdefgh/a/b/c', 1),
          Uri.parse('file:///a/b/c/version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl('file://abcdefgh/#my-page', 1),
          Uri.parse('file:///version.json?cachebuster=1'),
        );
        expect(
          plugin.versionJsonUrl('file://abcdefgh/a/b/c/#my-page', 1),
          Uri.parse('file:///a/b/c/version.json?cachebuster=1'),
        );
      });
    },
  );

  group('Package Info Web (using MockAssetManager)', () {
    setUp(() {
      client = MockClient();
      assetManagerMock = MockAssetManager();
      plugin = PackageInfoPlusWebPlugin(client, assetManagerMock);
    });

    testWidgets(
      'Get correct values when using the AssetManager baseUrl',
      (tester) async {
        const String baseUrl = 'https://an.example.com/using-asset-manager/';
        const String assetsDir = 'assets';
        final DateTime now = DateTime.now();
        final Clock fakeClock = Clock(() => now);

        when(assetManagerMock.assetsDir).thenReturn(assetsDir);
        when(assetManagerMock.getAssetUrl(''))
            .thenReturn('$baseUrl$assetsDir/');

        await withClock(fakeClock, () async {
          final int cache = now.millisecondsSinceEpoch;

          when(client.get(
            Uri.parse('${baseUrl}version.json?cachebuster=$cache'),
          )).thenAnswer(
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
        });
      },
    );

    testWidgets(
      'Has preference for the custom base URL over the other 2 locations',
      (tester) async {
        const String customBaseUrl = 'https://www.example.com/with-path/';
        const String managerBaseUrl = 'https://www.asset-manager.com/path/';
        const String assetsDir = 'assets';
        final DateTime now = DateTime.now();
        final Clock fakeClock = Clock(() => now);

        when(assetManagerMock.assetsDir).thenReturn(assetsDir);
        when(assetManagerMock.getAssetUrl(''))
            .thenReturn('$managerBaseUrl$assetsDir/');

        await withClock(fakeClock, () async {
          final int cache = now.millisecondsSinceEpoch;

          when(client.get(
            Uri.parse('${customBaseUrl}version.json?cachebuster=$cache'),
          )).thenAnswer(
            (_) => Future.value(
              http.Response(jsonEncode(VERSION_JSON), 200),
            ),
          );

          when(client.get(
            Uri.parse('${managerBaseUrl}version.json?cachebuster=$cache'),
          )).thenAnswer(
            (_) => Future.value(
              http.Response(jsonEncode(VERSION_2_JSON), 200),
            ),
          );

          final versionMap = await plugin.getAll(baseUrl: customBaseUrl);

          expect(versionMap.appName, VERSION_JSON['app_name']);
          expect(versionMap.version, VERSION_JSON['version']);
          expect(versionMap.buildNumber, VERSION_JSON['build_number']);
          expect(versionMap.packageName, VERSION_JSON['package_name']);
          expect(versionMap.buildSignature, VERSION_JSON['build_signature']);
        });
      },
    );
  });
}
