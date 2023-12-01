# battery_plus

[![Flutter Community: battery_plus](https://fluttercommunity.dev/_github/header/battery_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/battery_plus.svg)](https://pub.dev/packages/battery_plus)
[![pub points](https://img.shields.io/pub/points/battery_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/battery_plus/score)
[![battery_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/battery_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/battery_plus.yaml)

<p class="center">
<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>
</p>

A Flutter plugin to access various information about the battery of the device the app is running on.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :----: |
|   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅   |

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
// Currently available on Android, iOS and Windows platforms only
print(await battery.isInBatterySaveMode);
```

## Learn more

- [API Documentation](https://pub.dev/documentation/battery_plus/latest/battery_plus/battery_plus-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/battery_plus/overview)
