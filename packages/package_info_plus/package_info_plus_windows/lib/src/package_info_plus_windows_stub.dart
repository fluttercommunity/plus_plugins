import 'package:package_info_plus_platform_interface/package_info_data.dart';
import 'package:package_info_plus_platform_interface/package_info_platform_interface.dart';

/// A stub implementation to satisfy compilation of multi-platform packages that
/// depend on package_info_plus_windows. This should never actually be created.
///
/// Notably, because package_info_plus needs to manually register
/// package_info_plus_windows, anything with a transitive dependency on
/// package_info_plus will also depend on package_info_plus_windows, not just at
/// the pubspec level but the code level.
class PackageInfoWindows extends PackageInfoPlatform {
  /// Errors on attempted instantiation of the stub. It exists only to satisfy
  /// compile-time dependencies, and should never actually be created.
  PackageInfoWindows() {
    assert(false);
  }

  /// Stub
  @override
  Future<PackageInfoData> getAll() {
    throw UnimplementedError();
  }
}
