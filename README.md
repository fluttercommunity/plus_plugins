# Battery Plus

[![Flutter Community: batter_plus](https://fluttercommunity.dev/_github/header/batter_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/batter_plus.svg)](https://pub.dev/packages/batter_plus)

A Flutter plugin to access various information about the battery of the device the app is running on.

## Usage
To use this plugin, add `batter_plus` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

### Example

``` dart
// Import package
import 'package:batter_plus/battery.dart';

// Instantiate it
var battery = Battery();

// Access current battery level
print(await battery.batteryLevel);

// Be informed when the state (full, charging, discharging) changes
_battery.onBatteryStateChanged.listen((BatteryState state) {
  // Do something with new state
});
```
