// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart'
    show TestDefaultBinaryMessengerBinding, TestWidgetsFlutterBinding;
import 'package:mockito/mockito.dart';
import 'package:share_plus_platform_interface/method_channel/method_channel_share.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:test/test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockMethodChannel mockChannel;
  late SharePlatform sharePlatform;

  setUp(() {
    sharePlatform = SharePlatform();
    mockChannel = MockMethodChannel();
    // Re-pipe to mockito for easier verifies.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannelShare.channel,
            (MethodCall call) async {
      // The explicit type can be void as the only method call has a return type of void.
      await mockChannel.invokeMethod<void>(call.method, call.arguments);
      return null;
    });
  });

  test('can set SharePlatform instance', () {
    final currentId = identityHashCode(SharePlatform.instance);

    final newInstance = MethodChannelShare();
    final newInstanceId = identityHashCode(newInstance);

    expect(currentId, isNot(equals(newInstanceId)));
    expect(
      identityHashCode(SharePlatform.instance),
      equals(currentId),
    );
    SharePlatform.instance = newInstance;
    expect(
      identityHashCode(SharePlatform.instance),
      equals(newInstanceId),
    );
  });

  test('sharing empty fails', () {
    expect(
      () => sharePlatform.share(ShareParams()),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    expect(
      () => SharePlatform.instance.share(ShareParams()),
      throwsA(const TypeMatcher<AssertionError>()),
    );
    verifyZeroInteractions(mockChannel);
  });

  test('sharing origin sets the right params', () async {
    await sharePlatform.share(
      ShareParams(
        uri: Uri.parse('https://pub.dev/packages/share_plus'),
        sharePositionOrigin: const Rect.fromLTWH(1.0, 2.0, 3.0, 4.0),
      ),
    );
    verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
      'uri': 'https://pub.dev/packages/share_plus',
      'originX': 1.0,
      'originY': 2.0,
      'originWidth': 3.0,
      'originHeight': 4.0,
    }));

    await sharePlatform.share(
      ShareParams(
        text: 'some text to share',
        subject: 'some subject to share',
        sharePositionOrigin: const Rect.fromLTWH(1.0, 2.0, 3.0, 4.0),
      ),
    );
    verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
      'text': 'some text to share',
      'subject': 'some subject to share',
      'originX': 1.0,
      'originY': 2.0,
      'originWidth': 3.0,
      'originHeight': 4.0,
    }));

    await withFile('tempfile-83649a.png', (File fd) async {
      await sharePlatform.share(
        ShareParams(
          files: [XFile(fd.path)],
          subject: 'some subject to share',
          text: 'some text to share',
          sharePositionOrigin: const Rect.fromLTWH(1.0, 2.0, 3.0, 4.0),
        ),
      );
      verify(mockChannel.invokeMethod<String>(
        'share',
        <String, dynamic>{
          'paths': [fd.path],
          'mimeTypes': ['image/png'],
          'subject': 'some subject to share',
          'text': 'some text to share',
          'originX': 1.0,
          'originY': 2.0,
          'originWidth': 3.0,
          'originHeight': 4.0,
        },
      ));
    });
  });

  test('sharing file sets correct mimeType', () async {
    await withFile('tempfile-83649b.png', (File fd) async {
      await sharePlatform.share(ShareParams(files: [XFile(fd.path)]));
      verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
        'paths': [fd.path],
        'mimeTypes': ['image/png'],
      }));
    });
  });

  test('sharing file sets passed mimeType', () async {
    await withFile('tempfile-83649c.png', (File fd) async {
      await sharePlatform.share(
        ShareParams(
          files: [XFile(fd.path, mimeType: '*/*')],
        ),
      );
      verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
        'paths': [fd.path],
        'mimeTypes': ['*/*'],
      }));
    });
  });

  test('withResult methods return unavailable on non IOS & Android', () async {
    const resultUnavailable = ShareResult(
      'dev.fluttercommunity.plus/share/unavailable',
      ShareResultStatus.unavailable,
    );

    expect(
      sharePlatform.share(
        ShareParams(text: 'some text to share'),
      ),
      completion(equals(resultUnavailable)),
    );

    await withFile('tempfile-83649d.png', (File fd) async {
      expect(
        sharePlatform.share(
          ShareParams(
            files: [XFile(fd.path)],
          ),
        ),
        completion(equals(resultUnavailable)),
      );
    });
  });

  test('withResult methods invoke normal share on non IOS & Android', () async {
    // Setup mockito to return a raw result instead of null
    const success = ShareResult("raw result", ShareResultStatus.success);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannelShare.channel,
            (MethodCall call) async {
      await mockChannel.invokeMethod<void>(call.method, call.arguments);
      return success.raw;
    });

    final result = await sharePlatform.share(
      ShareParams(
        text: 'some text to share',
        subject: 'some subject to share',
        sharePositionOrigin: const Rect.fromLTWH(1.0, 2.0, 3.0, 4.0),
      ),
    );
    verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
      'text': 'some text to share',
      'subject': 'some subject to share',
      'originX': 1.0,
      'originY': 2.0,
      'originWidth': 3.0,
      'originHeight': 4.0,
    }));
    expect(result, success);

    await withFile('tempfile-83649e.png', (File fd) async {
      final result = await sharePlatform.share(
        ShareParams(
          files: [XFile(fd.path)],
        ),
      );
      verify(mockChannel.invokeMethod<String>('share', <String, dynamic>{
        'paths': [fd.path],
        'mimeTypes': ['image/png'],
      }));
      expect(result, success);
    });
  });
}

/// Execute a block within a context that handles creation and deletion of a helper file
Future<T> withFile<T>(String filename, Future<T> Function(File fd) func) async {
  final file = File(filename);
  try {
    file.createSync();
    return await func(file);
  } finally {
    file.deleteSync();
  }
}

// https://github.com/dart-lang/mockito/issues/316
class MockMethodChannel extends Mock implements MethodChannel {
  @override
  Future<T?> invokeMethod<T>(String method, [dynamic arguments]) async {
    return super
            .noSuchMethod(Invocation.method(#invokeMethod, [method, arguments]))
        as dynamic;
  }
}
