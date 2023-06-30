import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

import 'web_sensors.dart';

export 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

export 'web_sensors.dart';

final _sensors = WebSensorsPlugin();

/// A broadcast stream of events from the device accelerometer.
Stream<AttitudeEvent> get attitudeEvents {
  return _sensors.attitudeEvents;
}

/// A broadcast stream of events from the device accelerometer.
Stream<AccelerometerEvent> get accelerometerEvents {
  return _sensors.accelerometerEvents;
}

/// A broadcast stream of events from the device gyroscope.
Stream<GyroscopeEvent> get gyroscopeEvents {
  return _sensors.gyroscopeEvents;
}

/// Events from the device accelerometer with gravity removed.
Stream<UserAccelerometerEvent> get userAccelerometerEvents {
  return _sensors.userAccelerometerEvents;
}

/// A broadcast stream of events from the device magnetometer.
Stream<MagnetometerEvent> get magnetometerEvents {
  return _sensors.magnetometerEvents;
}
