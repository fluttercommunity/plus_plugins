# network_info_plus

[![Flutter Community: network_info_plus](https://fluttercommunity.dev/_github/header/network_info_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/network_info_plus.svg)](https://pub.dev/packages/network_info_plus)
[![pub points](https://img.shields.io/pub/points/network_info_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/network_info_plus/score)
[![network_info_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/network_info_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/network_info_plus.yaml)

<p class="center">
<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>
</p>

This plugin allows Flutter apps to discover network info and configure
themselves accordingly.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :----: |
|   ✔️    | ✔️  |  ✔️   | ➖  |  ✔️   |   ✔️   |

The functionality is not supported on Web.

## Usage

You can get Wi-Fi related information using:

```dart
import 'package:network_info_plus/network_info_plus.dart';

final info = NetworkInfo();

final wifiName = await info.getWifiName(); // "FooNetwork"
final wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
final wifiIP = await info.getWifiIP(); // 192.168.1.43
final wifiIPv6 = await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
final wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
final wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
final wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1
```

### Device permissions

To access protected WiFi methods related to location, you must request additional permissions on Android and iOS. Users of this plugin should use the [permission_handler](https://pub.dev/packages/permission_handler) Flutter plugin to handle these cases.

See below for platform-specific information on which permissions need to be requested for protected methods.

#### Android

To successfully get WiFi Name or Wi-Fi BSSID starting with Android 1O, ensure all of the following conditions are met:

- If your app is targeting Android 10 (API level 29) SDK or higher, your app needs to have the ACCESS_FINE_LOCATION permission.

- If your app is targeting SDK lower than Android 10 (API level 29), your app needs to have the ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION permission.

- Location services are enabled on the device (under Settings > Location).

- If you use device with Android 12 (API level 31) and newer be sure that your app has ACCESS_NETWORK_STATE permission.

> **Note**
>
> This package does not provide the ACCESS_FINE_LOCATION nor the ACCESS_COARSE_LOCATION permission by default

#### iOS 12

To use `.getWifiBSSID()` and `.getWifiName()` on iOS >= 12, the `Access WiFi information capability` in XCode must be enabled. Otherwise, both methods will return null.

#### iOS 13

The methods `.getWifiBSSID()` and `.getWifiName()` utilize the [`CNCopyCurrentNetworkInfo`](https://developer.apple.com/documentation/systemconfiguration/1614126-cncopycurrentnetworkinfo) function on iOS.

As of iOS 13, Apple announced that these APIs will no longer return valid information.
An app linked against iOS 12 or earlier receives pseudo-values such as:

- SSID: "Wi-Fi" or "WLAN" ("WLAN" will be returned for the China SKU).

- BSSID: "00:00:00:00:00:00"

An app linked against iOS 13 or later receives `null`.

The `CNCopyCurrentNetworkInfo` will work for Apps that:

- The app uses Core Location, and has the user’s authorization to use location information.

- The app uses the NEHotspotConfiguration API to configure the current Wi-Fi network.

- The app has active VPN configurations installed.

If your app falls into the last two categories, it will work as it is. If your app doesn't fall into the last two categories,
and you still need to access the wifi information, you should request user's authorization to use location information.

Make sure to add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

- `NSLocationAlwaysAndWhenInUseUsageDescription` - describe why the app needs access to the user’s location information all the time (foreground and background). This is called _Privacy - Location Always and When In Use Usage Description_ in the visual editor.
- `NSLocationWhenInUseUsageDescription` - describe why the app needs access to the user’s location information when the app is running in the foreground. This is called _Privacy - Location When In Use Usage Description_ in the visual editor.

## Learn more

[API Documentation](https://pub.dev/documentation/network_info_plus/latest/network_info_plus/network_info_plus-library.html).
[Plugin documentation website](https://plus.fluttercommunity.dev/docs/network_info_plus/overview)
