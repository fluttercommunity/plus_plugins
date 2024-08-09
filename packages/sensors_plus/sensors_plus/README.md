# sensors_plus

[![sensors_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/sensors_plus.yaml)
[![pub points](https://img.shields.io/pub/points/sensors_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/sensors_plus/score)
[![pub package](https://img.shields.io/pub/v/sensors_plus.svg)](https://pub.dev/packages/sensors_plus)

[<img src="../../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

A Flutter plugin to access the accelerometer, gyroscope, magnetometer and 
barometer sensors.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|   ✅   |   ✅   |   ❌   |   ✅*  |   ❌    |    ❌   |

\* Currently it is not possible to set sensors sampling rate on web

## Requirements

- Flutter >=3.19.0
- Dart >=3.3.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

## Usage

Add `sensors_plus` as a dependency in your pubspec.yaml file.
  
On iOS you must also include a key called [`NSMotionUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsmotionusagedescription) in your app's `Info.plist` file. This key provides a message that tells the user why the app is requesting access to the device’s motion data. The plugin itself needs access to motion data to get barometer data.

Example Info.plist entry:

```xml
<key>NSMotionUsageDescription</key>
<string>This app requires access to the barometer to provide altitude information.</string>
```

> [!CAUTION]
>
> Adding [`NSMotionUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsmotionusagedescription) is a requirement and not doing so will crash your app when it attempts to access motion data.

The plugin exposes such classes of sensor events through a set of streams:

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
- `BarometerEvent` describes the atmospheric pressure surrounding the device, in hPa. 
  An altimeter is an example usage of this data. Not supported on web browsers.

These events are exposed through a `BroadcastStream`: `accelerometerEvents`,
`userAccelerometerEvents`, `gyroscopeEvents`, `magnetometerEvents`, and `barometerEvents`,
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

barometerEvents.listen(
  (BarometerEvent event) {
    print(event);
  },
  onError: (error) {
    // Logic to handle error
    // Needed for Android in case sensor is not available
    },
  cancelOnError: true,
);
// [BarometerEvent (pressure: 1000.0)]
```

Alternatively, every stream allows to specify the sampling rate for its sensor using one of predefined constants or using a custom value.

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

### Platform Restrictions and Considerations

The following lists the restrictions for the sensors on certain platforms due to limitations of the platform. 

- **Magnetometer and Barometer missing for web**

  The Magnetometer API is currently not supported by any modern web browsers. Check browser compatibility matrix on [MDN docs for Magnetormeter API](https://developer.mozilla.org/en-US/docs/Web/API/Magnetometer). 

  The Barometer API does not exist for web platforms as can be seen at [MDN docs forn Sensors API](https://developer.mozilla.org/en-US/docs/Web/API/Sensor_APIs). 

  Developers should consider alternative methods or inform users about the limitation when their application runs on a web platform. 

> [!NOTE]
>
> Plugin won't crash the app in the case of usage on these platforms, but it is highly recommended to add onError() to handle such cases gracefully.

- **Sampling periods for web**

  Currently it is not possible to set sensors sampling rate on web. Calls to event streams at specied sampling periods will have the sampling period ignored. 

- **Barometer sampling period limitation for iOS**

  On iOS devices, barometer updates are [CMAltimeter](https://developer.apple.com/documentation/coremotion/cmaltimeter) which provides updates at regular intervals that cannot be controlled by the user. Calls to `barometerEventStream` at specied sampling periods will have the sampling period ignored. 

## Learn more

- [API Documentation](https://pub.dev/documentation/sensors_plus/latest/sensors_plus/sensors_plus-library.html)
