import 'dart:async';
import 'dart:developer' as developer;
import 'dart:html' as html
    show LinearAccelerationSensor, Accelerometer, Gyroscope, Magnetometer;
import 'dart:js_util';

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
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
    } catch (error) {
      if (onError != null) {
        onError();
      }

      /// Handle construction errors.
      ///
      /// If a feature policy blocks use of a feature it is because your code
      /// is inconsistent with the policies set on your server.
      /// This is not something that would ever be shown to a user.
      /// See Feature-Policy for implementation instructions in the browsers.
      if (error.toString().contains('SecurityError')) {
        /// See the note above about feature policy.
        developer.log('$apiName construction was blocked by a feature policy.',
            error: error);

        /// if this feature is not supported or Flag is not enabled yet!
      } else if (error.toString().contains('ReferenceError')) {
        developer.log('$apiName is not supported by the User Agent.',
            error: error);

        /// if this is unknown error, rethrow it
      } else {
        developer.log('Unknown error happened, rethrowing.');
        rethrow;
      }
    }
  }

  StreamController<AccelerometerEvent>? _accelerometerStreamController;
  late Stream<AccelerometerEvent> _accelerometerResultStream;

  // todo: make web also support setting samplingPeriod
  @override
  Stream<AccelerometerEvent> accelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_accelerometerStreamController == null) {
      _accelerometerStreamController = StreamController<AccelerometerEvent>();
      _featureDetected(
        () {
          final accelerometer = html.Accelerometer();

          setProperty(
            accelerometer,
            'onreading',
            allowInterop(
              (_) {
                _accelerometerStreamController!.add(
                  AccelerometerEvent(
                    accelerometer.x as double,
                    accelerometer.y as double,
                    accelerometer.z as double,
                  ),
                );
              },
            ),
          );

          accelerometer.start();

          accelerometer.onError.forEach(
            (e) => developer.log(
                'The accelerometer API is supported but something is wrong!',
                error: e),
          );
        },
        apiName: 'Accelerometer()',
        permissionName: 'accelerometer',
        onError: () {
          _accelerometerStreamController!.add(AccelerometerEvent(0, 0, 0));
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

  // todo: make web also support setting samplingPeriod
  @override
  Stream<GyroscopeEvent> gyroscopeEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_gyroscopeEventStreamController == null) {
      _gyroscopeEventStreamController = StreamController<GyroscopeEvent>();
      _featureDetected(
        () {
          final gyroscope = html.Gyroscope();

          setProperty(
            gyroscope,
            'onreading',
            allowInterop(
              (_) {
                _gyroscopeEventStreamController!.add(
                  GyroscopeEvent(
                    gyroscope.x as double,
                    gyroscope.y as double,
                    gyroscope.z as double,
                  ),
                );
              },
            ),
          );

          gyroscope.start();

          gyroscope.onError.forEach(
            (e) => developer.log(
                'The gyroscope API is supported but something is wrong!',
                error: e),
          );
        },
        apiName: 'Gyroscope()',
        permissionName: 'gyroscope',
        onError: () {
          _gyroscopeEventStreamController!.add(GyroscopeEvent(0, 0, 0));
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

  // todo: make web also support setting samplingPeriod
  @override
  Stream<UserAccelerometerEvent> userAccelerometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_userAccelerometerStreamController == null) {
      _userAccelerometerStreamController =
          StreamController<UserAccelerometerEvent>();
      _featureDetected(
        () {
          final linearAccelerationSensor = html.LinearAccelerationSensor();

          setProperty(
            linearAccelerationSensor,
            'onreading',
            allowInterop(
              (_) {
                _userAccelerometerStreamController!.add(
                  UserAccelerometerEvent(
                    linearAccelerationSensor.x as double,
                    linearAccelerationSensor.y as double,
                    linearAccelerationSensor.z as double,
                  ),
                );
              },
            ),
          );

          linearAccelerationSensor.start();

          linearAccelerationSensor.onError.forEach(
            (e) => developer.log(
                'The linear acceleration API is supported but something is wrong!',
                error: e),
          );
        },
        apiName: 'LinearAccelerationSensor()',
        permissionName: 'accelerometer',
        onError: () {
          _userAccelerometerStreamController!
              .add(UserAccelerometerEvent(0, 0, 0));
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

  // todo: make web also support setting samplingPeriod
  @override
  Stream<MagnetometerEvent> magnetometerEventStream({
    Duration samplingPeriod = SensorInterval.normalInterval,
  }) {
    if (_magnetometerStreamController == null) {
      _magnetometerStreamController = StreamController<MagnetometerEvent>();
      _featureDetected(
        () {
          final magnetometerSensor = html.Magnetometer();

          setProperty(
            magnetometerSensor,
            'onreading',
            allowInterop(
              (_) {
                _magnetometerStreamController!.add(
                  MagnetometerEvent(
                    magnetometerSensor.x as double,
                    magnetometerSensor.y as double,
                    magnetometerSensor.z as double,
                  ),
                );
              },
            ),
          );

          magnetometerSensor.start();

          magnetometerSensor.onError.forEach(
            (e) => developer.log(
                'The magnetometer API is supported but something is wrong!',
                error: e),
          );
        },
        apiName: 'Magnetometer()',
        permissionName: 'magnetometer',
        onError: () {
          _magnetometerStreamController!.add(MagnetometerEvent(0, 0, 0));
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
}
