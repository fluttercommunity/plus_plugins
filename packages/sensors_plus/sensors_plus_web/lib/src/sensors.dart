import 'dart:async';
import 'dart:html' as html
    show LinearAccelerationSensor, Accelerometer, Gyroscope, Magnetometer;
import 'dart:js';
import 'dart:js_util';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';
import 'dart:developer' as developer;

/// The sensors plugin.
class SensorsPlugin extends SensorsPlatform {
  /// Factory method that initializes the Sensors plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    SensorsPlatform.instance = SensorsPlugin();
  }

  void _featureDetected(
    Function initSensor, {
    String? apiName,
    String? premissionName,
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
        developer.log('$apiName construction was blocked by a feature policy.');

        /// if this feature is not supported or Flag is not enabled yet!
      } else if (error.toString().contains('ReferenceError')) {
        developer.log('$apiName is not supported by the User Agent.');

        /// if this is unknown error, rethrow it
      } else {
        rethrow;
      }
    }
  }

  StreamController<AccelerometerEvent>? _accelerometerStreamController;
  late Stream<AccelerometerEvent> _accelerometerResultStream;

  @override
  Stream<AccelerometerEvent> get accelerometerEvents {
    if (_accelerometerStreamController == null) {
      _accelerometerStreamController = StreamController<AccelerometerEvent>();
      _featureDetected(
        () {
          final _accelerometer = html.Accelerometer();

          setProperty(
            _accelerometer,
            'onreading',
            allowInterop(
              (_) {
                _accelerometerStreamController!.add(
                  AccelerometerEvent(
                    _accelerometer.x as double,
                    _accelerometer.y as double,
                    _accelerometer.z as double,
                  ),
                );
              },
            ),
          );

          _accelerometer.start();

          _accelerometer.onError.forEach(
            (e) => developer
                .log('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'Accelerometer()',
        premissionName: 'accelerometer',
        onError: () {
          _accelerometerStreamController!.add(AccelerometerEvent(0, 0, 0));
        },
      );
      _accelerometerResultStream =
          _accelerometerStreamController!.stream.asBroadcastStream();
    }

    return _accelerometerResultStream;
  }

  StreamController<GyroscopeEvent>? _gyroscopeEventStreamController;
  late Stream<GyroscopeEvent> _gyroscopeEventResultStream;

  @override
  Stream<GyroscopeEvent> get gyroscopeEvents {
    if (_gyroscopeEventStreamController == null) {
      _gyroscopeEventStreamController = StreamController<GyroscopeEvent>();
      _featureDetected(
        () {
          final _gyroscope = html.Gyroscope();

          setProperty(
            _gyroscope,
            'onreading',
            allowInterop(
              (_) {
                _gyroscopeEventStreamController!.add(
                  GyroscopeEvent(
                    _gyroscope.x as double,
                    _gyroscope.y as double,
                    _gyroscope.z as double,
                  ),
                );
              },
            ),
          );

          _gyroscope.start();

          _gyroscope.onError.forEach(
            (e) => developer
                .log('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'Gyroscope()',
        premissionName: 'gyroscope',
        onError: () {
          _gyroscopeEventStreamController!.add(GyroscopeEvent(0, 0, 0));
        },
      );
      _gyroscopeEventResultStream =
          _gyroscopeEventStreamController!.stream.asBroadcastStream();
    }

    return _gyroscopeEventResultStream;
  }

  StreamController<UserAccelerometerEvent>? _userAccelerometerStreamController;
  late Stream<UserAccelerometerEvent> _userAccelerometerResultStream;

  @override
  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    if (_userAccelerometerStreamController == null) {
      _userAccelerometerStreamController =
          StreamController<UserAccelerometerEvent>();
      _featureDetected(
        () {
          final _linearAccelerationSensor = html.LinearAccelerationSensor();

          setProperty(
            _linearAccelerationSensor,
            'onreading',
            allowInterop(
              (_) {
                _userAccelerometerStreamController!.add(
                  UserAccelerometerEvent(
                    _linearAccelerationSensor.x as double,
                    _linearAccelerationSensor.y as double,
                    _linearAccelerationSensor.z as double,
                  ),
                );
              },
            ),
          );

          _linearAccelerationSensor.start();

          _linearAccelerationSensor.onError.forEach(
            (e) => developer
                .log('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'LinearAccelerationSensor()',
        premissionName: 'accelerometer',
        onError: () {
          _userAccelerometerStreamController!
              .add(UserAccelerometerEvent(0, 0, 0));
        },
      );
      _userAccelerometerResultStream =
          _userAccelerometerStreamController!.stream.asBroadcastStream();
    }

    return _userAccelerometerResultStream;
  }

  StreamController<MagnetometerEvent>? _magnetometerStreamController;
  late Stream<MagnetometerEvent> _magnetometerResultStream;

  @override
  Stream<MagnetometerEvent> get magnetometerEvents {
    if (_magnetometerStreamController == null) {
      _magnetometerStreamController = StreamController<MagnetometerEvent>();
      _featureDetected(
        () {
          final _magnetometerSensor = html.Magnetometer();

          setProperty(
            _magnetometerSensor,
            'onreading',
            allowInterop(
              (_) {
                _magnetometerStreamController!.add(
                  MagnetometerEvent(
                    _magnetometerSensor.x as double,
                    _magnetometerSensor.y as double,
                    _magnetometerSensor.z as double,
                  ),
                );
              },
            ),
          );

          _magnetometerSensor.start();

          _magnetometerSensor.onError.forEach(
            (e) => developer
                .log('[SensorsPlugin] API supported but something is wrong: '
                    'Magnetometer $e'),
          );
        },
        apiName: 'Magnetometer()',
        premissionName: 'magnetometer',
        onError: () {
          _magnetometerStreamController!.add(MagnetometerEvent(0, 0, 0));
        },
      );
      _magnetometerResultStream =
          _magnetometerStreamController!.stream.asBroadcastStream();
    }

    return _magnetometerResultStream;
  }
}
