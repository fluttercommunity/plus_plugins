import 'dart:convert';

import 'package:device_info_plus_platform_interface/model/web_browser_info.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('$WebBrowserInfo', () {
    group('fromMap | toMap', () {
      final webBrowserInfoMap = <String, dynamic>{
        'appCodeName': 'appCodeName',
        'appName': 'appName',
        'appVersion': 'appVersion',
        'browserName': BrowserName.safari.name,
        'deviceMemory': 42,
        'language': 'language',
        'languages': ['en', 'es'],
        'platform': 'platform',
        'product': 'product',
        'productSub': 'productSub',
        'userAgent': 'Safari',
        'vendor': 'vendor',
        'vendorSub': 'vendorSub',
        'hardwareConcurrency': 2,
        'maxTouchPoints': 42,
      };

      test('fromMap should return $WebBrowserInfo with correct values', () {
        final webBrowserInfo = WebBrowserInfo.fromMap(webBrowserInfoMap);

        expect(webBrowserInfo.browserName, BrowserName.safari);
        expect(webBrowserInfo.appCodeName, 'appCodeName');
        expect(webBrowserInfo.appName, 'appName');
        expect(webBrowserInfo.appVersion, 'appVersion');
        expect(webBrowserInfo.deviceMemory, 42);
        expect(webBrowserInfo.language, 'language');
        expect(webBrowserInfo.languages, ['en', 'es']);
        expect(webBrowserInfo.platform, 'platform');
        expect(webBrowserInfo.product, 'product');
        expect(webBrowserInfo.productSub, 'productSub');
        expect(webBrowserInfo.userAgent, 'Safari');
        expect(webBrowserInfo.vendor, 'vendor');
        expect(webBrowserInfo.vendorSub, 'vendorSub');
        expect(webBrowserInfo.hardwareConcurrency, 2);
        expect(webBrowserInfo.maxTouchPoints, 42);
      });

      test('toJson should return map with correct key and map', () {
        final webBrowserInfo = WebBrowserInfo.fromMap(webBrowserInfoMap);
        expect(webBrowserInfo.toJson(), webBrowserInfoMap);
      });

      test('provided a map without `browserName` `userAgent` is parsed', () {
        final mapWithoutBrowserName = {...webBrowserInfoMap};
        mapWithoutBrowserName.remove('browserName');
        final webBrowserInfo = WebBrowserInfo.fromMap(mapWithoutBrowserName);
        expect(webBrowserInfo.toJson(), webBrowserInfoMap);
      });

      test('when `browserName` does not match `userAgent` throws Error', () {
        final wrongMap = {...webBrowserInfoMap};
        wrongMap['browserName'] = BrowserName.chrome.name;
        expect(
          () => WebBrowserInfo.fromMap(wrongMap),
          throwsA(isA<AssertionError>()),
        );
      });

      test('jsonEncode / jsonDecode should return the correct map', () {
        final webBrowserInfo = WebBrowserInfo.fromMap(webBrowserInfoMap);
        final json = jsonEncode(webBrowserInfo.toJson());
        expect(jsonDecode(json), webBrowserInfoMap);
      });
    });
  });
}
