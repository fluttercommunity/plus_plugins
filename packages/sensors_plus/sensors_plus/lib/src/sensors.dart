import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// The Sensors implementation.
class Sensors extends SensorsPlatform {
  /// Constructs a singleton instance of [Sensors].
  ///
  /// [Sensors] is designed to work as a singleton.
  factory Sensors() => _singleton ??= Sensors._();

  Sensors._();

  static Sensors? _singleton;

  static SensorsPlatform get _platform => SensorsPlatform.instance;

  /// Returns a broadcast stream of events from the device accelerometer at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.accelerometerEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a broadcast stream of events from the device gyroscope at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.gyroscopeEventStream(samplingPeriod: samplingPeriod);
  }

  /// Returns a broadcast stream of events from the device accelerometer with
  /// gravity removed at the given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.userAccelerometerEventStream(
        samplingPeriod: samplingPeriod);
  }

  /// Returns a broadcast stream of events from the device magnetometer at the
  /// given sampling frequency.
  ///
  /// This method always returning the same stream. If this method is called
  /// again, the sampling period of the stream will be update. All previous
  /// listener will also be affected.
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    return _platform.magnetometerEventStream(samplingPeriod: samplingPeriod);
  }
}
