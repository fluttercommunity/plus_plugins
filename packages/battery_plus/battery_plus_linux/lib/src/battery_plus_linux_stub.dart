import 'package:battery_plus_platform_interface/battery_plus_platform_interface.dart';

/// A stub implementation to satisfy compilation of multi-platform packages that
/// depend on battery_plus_linux. This should never actually be created.
///
/// Notably, because battery_plus needs to manually register battery_plus_linux,
/// anything with a transitive dependency on battery_plus will also depend on
/// battery_plus_linux, not just at the pubspec level but the code level.
class BatteryLinux extends BatteryPlatform {
  /// Errors on attempted instantiation of the stub. It exists only to satisfy
  /// compile-time dependencies, and should never actually be created.
  BatteryLinux() {
    assert(false);
  }
}
