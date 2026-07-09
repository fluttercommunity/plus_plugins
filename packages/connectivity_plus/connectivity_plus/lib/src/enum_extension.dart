import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';

extension ConnectivityResultListX on List<ConnectivityResult> {
  /// Returns whether any active network connection exists.
  bool get hasConnectivity =>
      !(length == 1 && first == ConnectivityResult.none);
}
