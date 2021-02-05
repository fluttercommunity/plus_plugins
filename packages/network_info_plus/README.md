# network_info_plus

[![Flutter Community: network_info_plus](https://fluttercommunity.dev/_github/header/network_info_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/network_info_plus.svg)](https://pub.dev/packages/network_info_plus)

This plugin allows Flutter apps to discover network info and configure
themselves accordingly.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Window |
|:-------:|:---:|:-----:|:---:|:-----:|:------:|
|    ✔️   |  ✔️ |   ✔️  |     |   ✔️  |   ✔️   |

## Usage

You can get wi-fi related information using:

```dart
import 'package:network_info_plus/network_info_plus.dart';

var wifiBSSID = await (NetworkInfo().getWifiBSSID());
var wifiIP = await (NetworkInfo().getWifiIP());network
var wifiName = await (NetworkInfo().getWifiName());wifi network
```

### iOS 12

To use `.getWifiBSSID()` and `.getWifiName()` on iOS >= 12, the `Access WiFi information capability` in XCode must be enabled. Otherwise, both methods will return null.

### iOS 13

The methods `.getWifiBSSID()` and `.getWifiName()` utilize the [`CNCopyCurrentNetworkInfo`](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo) function on iOS.

As of iOS 13, Apple announced that these APIs will no longer return valid information.
An app linked against iOS 12 or earlier receives pseudo-values such as:

 * SSID: "Wi-Fi" or "WLAN" ("WLAN" will be returned for the China SKU).

 * BSSID: "00:00:00:00:00:00"

An app linked against iOS 13 or later receives `null`.

The `CNCopyCurrentNetworkInfo` will work for Apps that:

  * The app uses Core Location, and has the user’s authorization to use location information.

  * The app uses the NEHotspotConfiguration API to configure the current Wi-Fi network.

  * The app has active VPN configurations installed.

If your app falls into the last two categories, it will work as it is. If your app doesn't fall into the last two categories,
and you still need to access the wifi information, you should request user's authorization to use location information.

There is a helper method provided in this plugin to request the location authorization: `requestLocationServiceAuthorization`.
To request location authorization, make sure to add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

* `NSLocationAlwaysAndWhenInUseUsageDescription` - describe why the app needs access to the user’s location information all the time (foreground and background). This is called _Privacy - Location Always and When In Use Usage Description_ in the visual editor.
* `NSLocationWhenInUseUsageDescription` - describe why the app needs access to the user’s location information when the app is running in the foreground. This is called _Privacy - Location When In Use Usage Description_ in the visual editor.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For help on editing plugin code, view the [documentation](https://flutter.dev/platform-plugins/#edit-code).
