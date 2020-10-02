import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';


class Sensors extends SensorsPlatform {
  /// Constructs a singleton instance of [Sensors].
  ///
  /// [Sensors] is designed to work as a singleton.
  factory Sensors() => _singleton ??= Sensors._();

  Sensors._();

  static Sensors _singleton;

  static SensorsPlatform get _platform => SensorsPlatform.instance;

  Stream<AccelerometerEvent> get accelerometerEvents {
    return _platform.accelerometerEvents;
  }

  Stream<GyroscopeEvent> get gyroscopeEvents {
    return _platform.gyroscopeEvents;
  }

  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    return _platform.userAccelerometerEvents;
  }
}
