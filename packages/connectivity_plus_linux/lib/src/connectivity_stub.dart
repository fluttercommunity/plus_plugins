import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

/// A stub implementation to satisfy compilation of multi-platform packages that
/// depend on connectivity_plus_linux. This should never actually be created.
///
/// Notably, because connectivity_plus needs to manually register
/// connectivity_plus_linux, anything with a transitive dependency on
/// connectivity_plus will also depend on connectivity_plus_linux, not just at
/// the pubspec level but the code level.
class ConnectivityLinux extends ConnectivityPlatform {
  /// Errors on attempted instantiation of the stub. It exists only to satisfy
  /// compile-time dependencies, and should never actually be created.
  ConnectivityLinux() {
    assert(false);
  }
}
