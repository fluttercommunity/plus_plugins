import 'dart:async';
import 'dart:html' as html
    show LinearAccelerationSensor, Accelerometer, Gyroscope;
import 'dart:js';
import 'dart:js_util';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:sensors_plus_platform_interface/sensors_plus_platform_interface.dart';

/// The sensors plugin.
class SensorsPlugin extends SensorsPlatform {
  /// Factory method that initializes the Battery plugin platform with an instance
  /// of the plugin for the web.
  static void registerWith(Registrar registrar) {
    SensorsPlatform.instance = SensorsPlugin();
  }

  void _featureDetected(
    Function initSensor, {
    String apiName,
    String premissionName,
    Function onError,
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
        print('$apiName construction was blocked by a feature policy.');

        /// if this feature is not supported or Flag is not enabled yet!
      } else if (error.toString().contains('ReferenceError')) {
        print('$apiName is not supported by the User Agent.');

        /// if this is unknown error, rethrow it
      } else {
        rethrow;
      }
    }
  }

  StreamController<AccelerometerEvent> _accelerometerStreamController;
  Stream<AccelerometerEvent> _accelerometerResultStream;

  Stream<AccelerometerEvent> get accelerometerEvents {
    if (_accelerometerStreamController == null) {
      _accelerometerStreamController = StreamController<AccelerometerEvent>();
      _featureDetected(
        () {
          final html.Accelerometer _accelerometer = html.Accelerometer();

          setProperty(
            _accelerometer,
            'onreading',
            allowInterop(
              (_) {
                _accelerometerStreamController.add(
                  AccelerometerEvent(
                    _accelerometer.x,
                    _accelerometer.y,
                    _accelerometer.z,
                  ),
                );
              },
            ),
          );

          _accelerometer.start();

          _accelerometer.onError.forEach(
            (e) => print('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'Accelerometer()',
        premissionName: 'accelerometer',
        onError: () {
          _accelerometerStreamController.add(AccelerometerEvent(0, 0, 0));
        },
      );
      _accelerometerResultStream =
          _accelerometerStreamController.stream.asBroadcastStream();
    }

    return _accelerometerResultStream;
  }

  StreamController<GyroscopeEvent> _gyroscopeEventStreamController;
  Stream<GyroscopeEvent> _gyroscopeEventResultStream;

  Stream<GyroscopeEvent> get gyroscopeEvents {
    if (_gyroscopeEventStreamController == null) {
      _gyroscopeEventStreamController = StreamController<GyroscopeEvent>();
      _featureDetected(
        () {
          final html.Gyroscope _gyroscope = html.Gyroscope();

          setProperty(
            _gyroscope,
            'onreading',
            allowInterop(
              (_) {
                _gyroscopeEventStreamController.add(
                  GyroscopeEvent(
                    _gyroscope.x,
                    _gyroscope.y,
                    _gyroscope.z,
                  ),
                );
              },
            ),
          );

          _gyroscope.start();

          _gyroscope.onError.forEach(
            (e) => print('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'Gyroscope()',
        premissionName: 'gyroscope',
        onError: () {
          _gyroscopeEventStreamController.add(GyroscopeEvent(0, 0, 0));
        },
      );
      _gyroscopeEventResultStream =
          _gyroscopeEventStreamController.stream.asBroadcastStream();
    }

    return _gyroscopeEventResultStream;
  }

  StreamController<UserAccelerometerEvent> _userAccelerometerStreamController;
  Stream<UserAccelerometerEvent> _userAccelerometerResultStream;

  Stream<UserAccelerometerEvent> get userAccelerometerEvents {
    if (_userAccelerometerStreamController == null) {
      _userAccelerometerStreamController =
          StreamController<UserAccelerometerEvent>();
      _featureDetected(
        () {
          final html.LinearAccelerationSensor _linearAccelerationSensor =
              html.LinearAccelerationSensor();

          setProperty(
            _linearAccelerationSensor,
            'onreading',
            allowInterop(
              (_) {
                _userAccelerometerStreamController.add(
                  UserAccelerometerEvent(
                    _linearAccelerationSensor.x,
                    _linearAccelerationSensor.y,
                    _linearAccelerationSensor.z,
                  ),
                );
              },
            ),
          );

          _linearAccelerationSensor.start();

          _linearAccelerationSensor.onError.forEach(
            (e) => print('The Api is supported but something is wrong! $e'),
          );
        },
        apiName: 'LinearAccelerationSensor()',
        premissionName: 'accelerometer',
        onError: () {
          _userAccelerometerStreamController
              .add(UserAccelerometerEvent(0, 0, 0));
        },
      );
      _userAccelerometerResultStream =
          _userAccelerometerStreamController.stream.asBroadcastStream();
    }

    return _userAccelerometerResultStream;
  }
}
