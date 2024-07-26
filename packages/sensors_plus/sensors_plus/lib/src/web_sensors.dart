import 'dart:async';
import 'dart:developer' as developer;
import 'dart:js_interop';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sensors_plus/src/web_sensors_interop.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// The sensors plugin.
class WebSensorsPlugin extends SensorsPlatform {
  /// Factory method that initializes the Sensors plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    SensorsPlatform.instance = WebSensorsPlugin();
  }

  void _featureDetected(
    Function initSensor, {
    String? apiName,
    String? permissionName,
    Function? onError,
  }) {
    try {
      initSensor();
    } on DOMException catch (e) {
      if (onError != null) {
        onError();
      }

      // Handle construction errors.
      //
      // If a feature policy blocks use of a feature it is because your code
      // is inconsistent with the policies set on your server.
      // This is not something that would ever be shown to a user.
      // See Feature-Policy for implementation instructions in the browsers.
      switch (e.name) {
        case 'TypeError':
          // if this feature is not supported or Flag is not enabled yet!
          developer.log(
            '$apiName is not supported by the User Agent.',
            error: '${e.name}: ${e.message}',
          );
        case 'SecurityError':
          // See the note above about feature policy.
          developer.log(
            '$apiName construction was blocked by a feature policy.',
            error: '${e.name}: ${e.message}',
          );
        default:
          // if this is unknown error, convert DOMException to Exception
          developer.log('Unknown error happened, rethrowing.');
          throw Exception('${e.name}: ${e.message}');
      }
    } on Error catch (_) {
      // DOMException is not caught as in release build
      // so we need to catch it as Error
      if (onError != null) {
        onError();
      }
    }
  }

  StreamController<AccelerometerEvent>? _accelerometerStreamController;
  late Stream<AccelerometerEvent> _accelerometerResultStream;

  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_accelerometerStreamController == null) {
      _accelerometerStreamController = StreamController<AccelerometerEvent>();
      _featureDetected(
        () {
          final accelerometer = Accelerometer(
            SensorOptions(
              frequency: samplingPeriod.frequency,
            ),
          );

          accelerometer.start();

          accelerometer.onreading = (Event _) {
            _accelerometerStreamController!.add(
              AccelerometerEvent(
                accelerometer.x,
                accelerometer.y,
                accelerometer.z,
                DateTime.now(),
              ),
            );
          }.toJS;

          accelerometer.onerror = (SensorErrorEvent e) {
            developer.log(
              'The accelerometer API is supported but something is wrong!',
              error: e.error.message,
            );
          }.toJS;
        },
        apiName: 'Accelerometer()',
        permissionName: 'accelerometer',
        onError: () {
          _accelerometerStreamController!
              .add(AccelerometerEvent(0, 0, 0, DateTime.now()));
        },
      );
      _accelerometerResultStream =
          _accelerometerStreamController!.stream.asBroadcastStream();

      _accelerometerStreamController!.onCancel = () {
        _accelerometerStreamController!.close();
      };
    }

    return _accelerometerResultStream;
  }

  StreamController<GyroscopeEvent>? _gyroscopeEventStreamController;
  late Stream<GyroscopeEvent> _gyroscopeEventResultStream;

  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_gyroscopeEventStreamController == null) {
      _gyroscopeEventStreamController = StreamController<GyroscopeEvent>();
      _featureDetected(
        () {
          final gyroscope = Gyroscope(
            SensorOptions(
              frequency: samplingPeriod.frequency,
            ),
          );

          gyroscope.start();

          gyroscope.onreading = (Event _) {
            _gyroscopeEventStreamController!.add(
              GyroscopeEvent(
                gyroscope.x,
                gyroscope.y,
                gyroscope.z,
                DateTime.now(),
              ),
            );
          }.toJS;

          gyroscope.onerror = (SensorErrorEvent e) {
            developer.log(
              'The gyroscope API is supported but something is wrong!',
              error: e.error.message,
            );
          }.toJS;
        },
        apiName: 'Gyroscope()',
        permissionName: 'gyroscope',
        onError: () {
          _gyroscopeEventStreamController!
              .add(GyroscopeEvent(0, 0, 0, DateTime.now()));
        },
      );
      _gyroscopeEventResultStream =
          _gyroscopeEventStreamController!.stream.asBroadcastStream();

      _gyroscopeEventStreamController!.onCancel = () {
        _gyroscopeEventStreamController!.close();
      };
    }

    return _gyroscopeEventResultStream;
  }

  StreamController<UserAccelerometerEvent>? _userAccelerometerStreamController;
  late Stream<UserAccelerometerEvent> _userAccelerometerResultStream;

  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_userAccelerometerStreamController == null) {
      _userAccelerometerStreamController =
          StreamController<UserAccelerometerEvent>();
      _featureDetected(
        () {
          final linearAccelerationSensor = LinearAccelerationSensor(
            SensorOptions(
              frequency: samplingPeriod.frequency,
            ),
          );

          linearAccelerationSensor.start();

          linearAccelerationSensor.onreading = (Event _) {
            _gyroscopeEventStreamController!.add(
              GyroscopeEvent(
                linearAccelerationSensor.x,
                linearAccelerationSensor.y,
                linearAccelerationSensor.z,
                DateTime.now(),
              ),
            );
          }.toJS;

          linearAccelerationSensor.onerror = (SensorErrorEvent e) {
            developer.log(
              'The linear acceleration API is supported but something is wrong!',
              error: e.error.message,
            );
          }.toJS;
        },
        apiName: 'LinearAccelerationSensor()',
        permissionName: 'accelerometer',
        onError: () {
          _userAccelerometerStreamController!
              .add(UserAccelerometerEvent(0, 0, 0, DateTime.now()));
        },
      );
      _userAccelerometerResultStream =
          _userAccelerometerStreamController!.stream.asBroadcastStream();

      _userAccelerometerStreamController!.onCancel = () {
        _userAccelerometerStreamController!.close();
      };
    }

    return _userAccelerometerResultStream;
  }

  StreamController<MagnetometerEvent>? _magnetometerStreamController;
  late Stream<MagnetometerEvent> _magnetometerResultStream;

  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    // The Magnetometer API is not supported by any modern browser.
    if (_magnetometerStreamController == null) {
      _magnetometerStreamController = StreamController<MagnetometerEvent>();
      _featureDetected(
        () {
          final magnetometerSensor = Magnetometer(
            SensorOptions(
              frequency: samplingPeriod.frequency,
            ),
          );

          magnetometerSensor.start();

          magnetometerSensor.onreading = (Event _) {
            _gyroscopeEventStreamController!.add(
              GyroscopeEvent(
                magnetometerSensor.x,
                magnetometerSensor.y,
                magnetometerSensor.z,
                DateTime.now(),
              ),
            );
          }.toJS;

          magnetometerSensor.onerror = (SensorErrorEvent e) {
            developer.log(
              'The magnetometer API is supported but something is wrong!',
              error: e,
            );
          }.toJS;
        },
        apiName: 'Magnetometer()',
        permissionName: 'magnetometer',
        onError: () {
          _magnetometerStreamController!
              .add(MagnetometerEvent(0, 0, 0, DateTime.now()));
        },
      );
      _magnetometerResultStream =
          _magnetometerStreamController!.stream.asBroadcastStream();

      _magnetometerStreamController!.onCancel = () {
        _magnetometerStreamController!.close();
      };
    }

    return _magnetometerResultStream;
  }

  @override
  Stream<BarometerEvent> barometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    // The Barometer API does not exist and so is not supported by any modern browser.
    // Therefore, we simply return an empty stream.
    return const Stream.empty();
  }
}

extension on Duration {
  /// Converts the duration to a frequency in Hz.
  int get frequency {
    if (inMicroseconds <= 10) {
      return 100;
    }

    return 1000 ~/ inMilliseconds;
  }
}
