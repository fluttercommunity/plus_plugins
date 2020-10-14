import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:html' as html;

import 'package:share_plus_web/share_plus_web.dart';

class _MockWindow extends Mock implements html.Window {}

class _MockNavigator extends Mock implements html.Navigator {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('SharePlugin', () {
    _MockWindow mockWindow;
    _MockNavigator mockNavigator;

    SharePlugin plugin;

    setUp(() {
      mockWindow = _MockWindow();
      mockNavigator = _MockNavigator();
      when(mockWindow.navigator).thenReturn(mockNavigator);

      plugin = SharePlugin(debugNavigator: mockNavigator);
    });
    group('share', () {
      testWidgets('can share url', (WidgetTester _) async {
        expect(plugin.share('https://google.com'), completes);
      });
      testWidgets('can share text with subject', (WidgetTester _) async {
        expect(plugin.share('flutter', subject: 'test'), completes);
      });
    });
  });
}
