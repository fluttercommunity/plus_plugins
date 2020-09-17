import 'package:package_info_plus_platform_interface/package_info.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_package_info.dart';

/// The interface that implementations of package_info must implement.
///
/// Platform implementations should extend this class rather than implement it as `package_info`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [PackageInfoPlatform] methods.
abstract class PackageInfoPlatform extends PlatformInterface {
  /// Constructs a PackageInfoPlusPlatform.
  PackageInfoPlatform() : super(token: _token);

  static final Object _token = Object();

  /// The default instance of [PackageInfoPlatform] to use.
  static PackageInfoPlatform _instance = MethodChannelPackageInfo();

  /// Defaults to [MethodChannelPackageInfo].
  static PackageInfoPlatform get instance => _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [PackageInfoPlatform] when they register themselves.
  static set instance(PackageInfoPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///Returns a map with the following keys : appName,packageName,version,buildNumber
  Future<PackageInfo> getAll() {
    throw UnimplementedError('getAll() has not been implemented.');
  }
}
