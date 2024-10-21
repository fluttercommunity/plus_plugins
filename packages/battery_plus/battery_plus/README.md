# battery_plus

[![pub package](https://img.shields.io/pub/v/battery_plus.svg)](https://pub.dev/packages/battery_plus)
[![pub points](https://img.shields.io/pub/points/battery_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/battery_plus/score)
[![battery_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/battery_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/battery_plus.yaml)

[<img src="../../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

A Flutter plugin to access various information about the battery of the device the app is running on.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅   |

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

Add `battery_plus` as a dependency in your pubspec.yaml file.

### Example

```dart
// Import package
import 'package:battery_plus/battery_plus.dart';

// Instantiate it
var battery = Battery();

// Access current battery level
print(await battery.batteryLevel);

// Be informed when the state (full, charging, discharging) changes
battery.onBatteryStateChanged.listen((BatteryState state) {
  // Do something with new state
});

// Check if device in battery save mode
// Currently available on Android, iOS, MacOS and Windows platforms only
print(await battery.isInBatterySaveMode);
```

## Learn more

- [API Documentation](https://pub.dev/documentation/battery_plus/latest/battery_plus/battery_plus-library.html)
