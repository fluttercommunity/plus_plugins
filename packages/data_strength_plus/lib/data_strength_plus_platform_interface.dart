import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'data_strength_plus_method_channel.dart';

abstract class DataStrengthPlusPlatform extends PlatformInterface {
  /// Constructs a DataStrengthPlusPlatform.
  DataStrengthPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static DataStrengthPlusPlatform _instance = MethodChannelDataStrengthPlus();

  /// The default instance of [DataStrengthPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelDataStrengthPlus].
  static DataStrengthPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DataStrengthPlusPlatform] when
  /// they register themselves.
  static set instance(DataStrengthPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<int?> getMobileSignalStrength() {
    throw UnimplementedError(
        'getMobileSignalStrength() has not been implemented.');
  }

  Future<int?> getWifiSignalStrength() {
    throw UnimplementedError(
        'getWifiSignalStrength() has not been implemented.');
  }

  Future<int?> getWifiLinkSpeed() {
    throw UnimplementedError('getWifiLinkSpeed() has not been implemented.');
  }
}
