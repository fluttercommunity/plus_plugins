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

You can get wi-fi related information using:

```dart
import 'package:network_info_plus/network_info_plus.dart';

final info = NetworkInfo();

var wifiName = await info.getWifiName(); // FooNetwork
var wifiBSSID = await info.getWifiBSSID(); // 11:22:33:44:55:66
var wifiIP = await info.getWifiIP(); // 192.168.1.43
var wifiIPv6 = await info.getWifiIPv6(); // 2001:0db8:85a3:0000:0000:8a2e:0370:7334
var wifiSubmask = await info.getWifiSubmask(); // 255.255.255.0
var wifiBroadcast = await info.getWifiBroadcast(); // 192.168.1.255
var wifiGateway = await info.getWifiGatewayIP(); // 192.168.1.1
```

### Android

Your app must target API level 33 (Android 13) or higher to use this plugin to support the latest `NEARBY_WIFI_DEVICES` permission.

```groovy
// app/build.gradle
...
android {
    compileSdkVersion 33
    defaultConfig {
        ...
        targetSdkVersion 33
    }
}
```

To successfully get WiFi Name or Wi-Fi BSSID starting with Android 1O, ensure all of the following conditions are met:

- If your app supports Android 13 (API level 33) or higher, you must add the `NEARBY_WIFI_DEVICES` permission to `AndroidManifest.xml`.

- If your app supports Android 10 (API level 29) SDK or higher, you must add the `ACCESS_FINE_LOCATION` permission to `AndroidManifest.xml`.

- If your app supports lower than Android 10 (API level 29) SDK, you must add the `ACCESS_COARSE_LOCATION` permission.

```xml
<!-- AndroidManifest.xml -->
...
<!-- Android >=13 -->
<uses-permission
        android:name="android.permission.NEARBY_WIFI_DEVICES"
        android:usesPermissionFlags="neverForLocation" />
<!-- Android 10-12 -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<!-- Android <10 -->
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

- Location services are enabled on the device (under Settings > Location).

There is a helper method provided in this plugin to request the location authorization: `requestLocationServiceAuthorization`.

### iOS 12

To use `.getWifiBSSID()` and `.getWifiName()` on iOS >= 12, the `Access WiFi information capability` in XCode must be enabled. Otherwise, both methods will return null.

### iOS 13

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

There is a helper method provided in this plugin to request the location authorization: `requestLocationServiceAuthorization`.
To request location authorization, make sure to add the following keys to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

- `NSLocationAlwaysAndWhenInUseUsageDescription` - describe why the app needs access to the user’s location information all the time (foreground and background). This is called _Privacy - Location Always and When In Use Usage Description_ in the visual editor.
- `NSLocationWhenInUseUsageDescription` - describe why the app needs access to the user’s location information when the app is running in the foreground. This is called _Privacy - Location When In Use Usage Description_ in the visual editor.

Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)
