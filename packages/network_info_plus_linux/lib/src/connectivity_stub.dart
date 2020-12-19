import 'package:network_info_plus_platform_interface/network_info_plus_platform_interface.dart';

/// A stub implementation to satisfy compilation of multi-platform packages that
/// depend on network_info_plus_linux. This should never actually be created.
///
/// Notably, because network_info_plus needs to manually register
/// network_info_plus_linux, anything with a transitive dependency on
/// network_info_plus will also depend on network_info_plus_linux, not just at
/// the pubspec level but the code level.
class ConnectivityLinux extends ConnectivityPlatform {
  /// Errors on attempted instantiation of the stub. It exists only to satisfy
  /// compile-time dependencies, and should never actually be created.
  ConnectivityLinux() {
    assert(false);
  }
}
