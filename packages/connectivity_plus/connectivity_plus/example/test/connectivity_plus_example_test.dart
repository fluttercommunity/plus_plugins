//@dart=2.9

// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

void main() {
 // IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Connectivity test driver', () {
    Connectivity _connectivity;

    setUpAll(() async {
      _connectivity = Connectivity();
    });

    testWidgets('test connectivity result', (WidgetTester tester) async {
      print("11111111");
      final result = await _connectivity.checkConnectivity();
      print("22222222");
      expect(result, isNotNull);
      print("33333333333");
    });
  });
}
