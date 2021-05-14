import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:package_info_plus_web/package_info_plus_web.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PackageInfoWebPlugin', () {
    late PackageInfoPlugin plugin;

    setUp(() {
      plugin = PackageInfoPlugin();
    });

    group('Package Info', () {
      testWidgets(
        'Get correct valaues when response status is 200',
        (WidgetTester _) async {
          final versionMap = await plugin.getAll();
          expect(versionMap.appName, 'regular_integration_tests');
          expect(versionMap.buildNumber, '1');
          expect(versionMap.packageName, isEmpty);
          expect(versionMap.version, '1.0.0');
        },
      );
    });
  });
}
