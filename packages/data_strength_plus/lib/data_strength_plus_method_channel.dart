import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'data_strength_plus_platform_interface.dart';

/// An implementation of [DataStrengthPlusPlatform] that uses method channels.
class MethodChannelDataStrengthPlus extends DataStrengthPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('data_strength_plus');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  Future<int?> getMobileSignalStrength() async {
    final data = await methodChannel.invokeMethod('getMobileSignalStrength');
    return data;
  }

  Future<int?> getWifiSignalStrength() async {
    final data = await methodChannel.invokeMethod('getWifiSignalStrength');
    return data;
  }

  Future<int?> getWifiLinkSpeed() async {
    final data = await methodChannel.invokeMethod('getWifiLinkSpeed');
    return data;
  }
}
