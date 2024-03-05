import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'web_sensors.dart';

export 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

export 'web_sensors.dart';

final _sensors = WebSensorsPlugin();

/// A broadcast stream of events from the device accelerometer.
@Deprecated('Use accelerometerEventStream() instead.')
Stream<AccelerometerEvent> get accelerometerEvents {
  return _sensors.accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
@Deprecated('Use gyroscopeEventStream() instead.')
Stream<GyroscopeEvent> get gyroscopeEvents {
  return _sensors.gyroscopeEvents;
}

/// Events from the device accelerometer with gravity removed.
@Deprecated('Use userAccelerometerEventStream() instead.')
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  return _sensors.userAccelerometerEvents;
}

/// A broadcast stream of events from the device magnetometer.
@Deprecated('Use magnetometerEventStream() instead.')
Stream<MagnetometerEvent> get magnetometerEvents {
  return _sensors.magnetometerEvents;
}

/// Returns a broadcast stream of events from the device accelerometer at the
/// given sampling frequency.
@override
Stream<AccelerometerEvent> accelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.accelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device gyroscope at the
/// given sampling frequency.
@override
Stream<GyroscopeEvent> gyroscopeEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.gyroscopeEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device accelerometer with
/// gravity removed at the given sampling frequency.
@override
Stream<UserAccelerometerEvent> userAccelerometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.userAccelerometerEventStream(samplingPeriod: samplingPeriod);
}

/// Returns a broadcast stream of events from the device magnetometer at the
/// given sampling frequency.
@override
Stream<MagnetometerEvent> magnetometerEventStream({
  Duration samplingPeriod = SensorInterval.normalInterval,
}) {
  return _sensors.magnetometerEventStream(samplingPeriod: samplingPeriod);
}
