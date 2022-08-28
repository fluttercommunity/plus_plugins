// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.9

import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Can launch share', (WidgetTester tester) async {
    expect(Share.share('message', subject: 'title'), completes);
  });

  testWidgets('Can launch shareWithResult', (WidgetTester tester) async {
    expect(Share.shareWithResult('message', subject: 'title'), isNotNull);
  });
}
