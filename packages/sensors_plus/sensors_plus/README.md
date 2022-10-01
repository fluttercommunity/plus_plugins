# Sensors Plus

[![Flutter Community: sensors_plus](https://fluttercommunity.dev/_github/header/sensors_plus)](https://github.com/fluttercommunity/community)

[![sensors_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml)
[![pub package](https://img.shields.io/pub/v/battery_plus.svg)](https://pub.dev/packages/battery_plus)

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a>

A Flutter plugin to access the accelerometer, gyroscope, and magnetometer
sensors.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ✔️   |   ✔️   |      |   ✔️  |       |         |

## Usage

To use this plugin, add `sensors_plus` as a [dependency in your pubspec.yaml
file](https://plus.fluttercommunity.dev/docs/overview).

This will expose four classes of sensor events through four different
streams.

- `AccelerometerEvent`s describe the velocity of the device, including the
  effects of gravity. Put simply, you can use accelerometer readings to tell if
  the device is moving in a particular direction.
- `UserAccelerometerEvent`s also describe the velocity of the device, but don't
  include gravity. They can also be thought of as just the user's affect on the
  device.
- `GyroscopeEvent`s describe the rotation of the device.
- `MagnetometerEvent`s describe the ambient magnetic field surrounding the
  device. A compass is an example usage of this data.

Each of these is exposed through a `BroadcastStream`: `accelerometerEvents`,
`userAccelerometerEvents`, `gyroscopeEvents`, and `magnetometerEvents`,
respectively.

### Example

```dart
import 'package:sensors_plus/sensors_plus.dart';

accelerometerEvents.listen((AccelerometerEvent event) {
  print(event);
});
// [AccelerometerEvent (x: 0.0, y: 9.8, z: 0.0)]

userAccelerometerEvents.listen((UserAccelerometerEvent event) {
  print(event);
});
// [UserAccelerometerEvent (x: 0.0, y: 0.0, z: 0.0)]

gyroscopeEvents.listen((GyroscopeEvent event) {
  print(event);
});
// [GyroscopeEvent (x: 0.0, y: 0.0, z: 0.0)]

magnetometerEvents.listen((MagnetometerEvent event) {
  print(event);
});
// [MagnetometerEvent (x: -23.6, y: 6.2, z: -34.9)]

```

Also see the `example` subdirectory for an example application that uses the
sensor data.

Check out our website to learn more: [Plus Plugins documentation](https://plus.fluttercommunity.dev/docs/overview)
