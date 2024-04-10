// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can launch share', (WidgetTester tester) async {
    // Check isNotNull because we cannot wait for ShareResult
    expect(Share.share('message', subject: 'title'), isNotNull);
  });

  testWidgets('Can launch shareUri', (WidgetTester tester) async {
    // Check isNotNull because we cannot wait for ShareResult
    expect(Share.shareUri(Uri.parse('https://example.com')), isNotNull);
  }, skip: !Platform.isAndroid && !Platform.isIOS);

  testWidgets('Can shareXFile created using File.fromData()',
      (WidgetTester tester) async {
    final bytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
    final XFile file =
        XFile.fromData(bytes, name: 'image.jpg', mimeType: 'image/jpeg');

    expect(Share.shareXFiles([file], text: "example"), isNotNull);
  });
}
