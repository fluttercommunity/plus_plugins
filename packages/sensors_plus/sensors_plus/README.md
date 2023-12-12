# sensors_plus

[![Flutter Community: sensors_plus](https://fluttercommunity.dev/_github/header/sensors_plus)](https://github.com/fluttercommunity/community)

[![sensors_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml)
[![pub points](https://img.shields.io/pub/points/sensors_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/sensors_plus/score)
[![pub package](https://img.shields.io/pub/v/sensors_plus.svg)](https://pub.dev/packages/sensors_plus)

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a>

A Flutter plugin to access the accelerometer, gyroscope, and magnetometer
sensors.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ✅   |   ✅   |   ❌   |   ✅*  |   ❌    |    ❌   |

\* Currently it is not possible to set sensors sampling rate on web

## Usage

Add `sensors_plus` as a dependency in your pubspec.yaml file.

This will expose such classes of sensor events through a set of streams:

- `UserAccelerometerEvent` describes the acceleration of the device, in m/s<sup>2</sup>.
  If the device is still, or is moving along a straight line at constant speed,
  the reported acceleration is zero.
  If the device is moving e.g. towards north and its speed is increasing, the reported acceleration
  is towards north; if it is slowing down, the reported acceleration is towards south;
  if it is turning right, the reported acceleration is towards east.
  The data of this stream is obtained by filtering out the effect of gravity from `AccelerometerEvent`.
- `AccelerometerEvent` describes the acceleration of the device, in m/s<sup>2</sup>, including the
  effects of gravity. Unlike `UserAccelerometerEvent`, this stream reports raw data from
  the accelerometer (physical sensor embedded in the mobile device) without any post-processing.
  The accelerometer is unable to distinguish between the effect of an accelerated movement of the
  device and the effect of the surrounding gravitational field.
  This means that, at the surface of Earth, even if the device is completely still,
  the reading of `AccelerometerEvent` is an acceleration of intensity 9.8 directed upwards
  (the opposite of the graviational acceleration).
  This can be used to infer information about the position of the device (horizontal/vertical/tilted).
  `AccelerometerEvent` reports zero acceleration if the device is free falling.
- `GyroscopeEvent` describes the rotation of the device.
- `MagnetometerEvent` describes the ambient magnetic field surrounding the
  device. A compass is an example usage of this data.

These events are exposed through a `BroadcastStream`: `accelerometerEvents`,
`userAccelerometerEvents`, `gyroscopeEvents`, and `magnetometerEvents`,
respectively.

> [!NOTE]
>
> Some low end or old Android devices don't have all sensors available. Plugin won't crash the app,
> but it is highly recommended to add onError() to handle such cases gracefully.

### Example

```dart
import 'package:sensors_plus/sensors_plus.dart';

accelerometerEvents.listen(
  (AccelerometerEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

userAccelerometerEvents.listen(
  (UserAccelerometerEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

gyroscopeEvents.listen(
  (GyroscopeEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

magnetometerEvents.listen(
  (MagnetometerEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
// [MagnetometerEvent (x: -23.6, y: 6.2, z: -34.9)]
```

Alternatively, every stream allows to specify the sampling rate for its sensor using one of predefined constants or using a custom value

> [!NOTE]
>
> On Android it is not guaranteed that events from sensors will arrive with specified sampling rate as it is noted in [the official Android documentation](https://developer.android.com/reference/android/hardware/SensorManager.html#registerListener(android.hardware.SensorEventListener,%20android.hardware.Sensor,%20int)) (see the description for the `samplingPeriodUs` parameter). In reality delay varies depending on Android version, device hardware and vendor's OS customisations.


```dart
magnetometerEvents(samplingPeriod: SensorInterval.normalInterval).listen(
  (MagnetometerEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
```

For more detailed instruction check out the documentation linked below.
Also see the `example` subdirectory for an example application that uses the
sensor data.

## Learn more

- [API Documentation](https://pub.dev/documentation/sensors_plus/latest/sensors_plus/sensors_plus-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/sensors_plus/overview)
