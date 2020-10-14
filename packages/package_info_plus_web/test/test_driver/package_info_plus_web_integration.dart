import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_web/package_info_plus_web.dart';

@TestOn('chrome')
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('package_info', () {
    PackageInfoPlugin packageInfoPlugin;
    MockPackageInfoPlugin fakePlatform;
    setUp(() async {
      fakePlatform = MockPackageInfoPlugin();
      packageInfoPlugin = fakePlatform;
    });
    test('package_info', () async {
      PackageInfoData packageInfoData = await packageInfoPlugin.getAll();
      expect(packageInfoData.appName, "Package Info Test");
    });
  });
}

class MockPackageInfoPlugin extends Mock implements PackageInfoPlugin {
  Future<PackageInfoData> getAll() async {
    return PackageInfoData(
      appName: "Package Info Test",
      buildNumber: "1",
      packageName: "package_info_test",
      version: "1.0.0",
    );
  }
}
