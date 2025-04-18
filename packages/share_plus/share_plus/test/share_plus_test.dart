import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  late FakeSharePlatform fakePlatform;
  late SharePlus sharePlus;

  setUp(() {
    fakePlatform = FakeSharePlatform();
    sharePlus = SharePlus.custom(fakePlatform);
  });

  group('SharePlus', () {
    test('share throws ArgumentError if no params are provided', () async {
      expect(
        () => sharePlus.share(ShareParams()),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('share throws ArgumentError if both uri and text are provided',
        () async {
      expect(
        () => sharePlus.share(
          ShareParams(
            uri: Uri.parse('https://example.com'),
            text: 'text',
          ),
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('share throws ArgumentError if text is empty', () async {
      expect(
        () => sharePlus.share(ShareParams(text: '')),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('share throws ArgumentError if files are empty', () async {
      expect(
        () => sharePlus.share(ShareParams(files: [])),
        throwsA(isA<ArgumentError>()),
      );
    });

    test(
        'share throws ArgumentError if fileNameOverrides length does not match files length',
        () async {
      expect(
        () => sharePlus.share(ShareParams(
            files: [XFile('path')], fileNameOverrides: ['name1', 'name2'])),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('share calls platform share method with correct params', () async {
      final params = ShareParams(text: 'text');
      final result = await sharePlus.share(params);
      expect(result, ShareResult.unavailable);
      expect(fakePlatform.lastParams?.text, params.text);
    });
  });
}

class FakeSharePlatform implements SharePlatform {
  ShareParams? lastParams;
  @override
  Future<ShareResult> share(ShareParams params) {
    lastParams = params;
    return Future.value(ShareResult.unavailable);
  }
}
