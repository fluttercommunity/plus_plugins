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
|   ✅    | ✅  |  ✅   | ❌  |  ✅   |   ✅   |

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

### Android

**Wi-Fi Name in quotes**

The Android OS will return the Wi-Fi name surrounded in quotes. e.g. `"WiFi Name"` instead of `Wifi Name`.
These double quotes are added by the operating system, but only when the original Wi-Fi name doesn't contain
quotes already. The plugin will always return the Wi-Fi name as provided by the OS.

This is a known limitation, do not create bug reports about this.

#### Permissions on Android

To successfully get WiFi Name or Wi-Fi BSSID starting with Android 1O, ensure all of the following conditions are met:

- If your app is targeting Android 10 (API level 29) SDK or higher, your app needs to have the ACCESS_FINE_LOCATION permission.

- If your app is targeting SDK lower than Android 10 (API level 29), your app needs to have the ACCESS_COARSE_LOCATION or ACCESS_FINE_LOCATION permission.

- Location services are enabled on the device (under Settings > Location).

- If you use device with Android 12 (API level 31) and newer be sure that your app has ACCESS_NETWORK_STATE permission.

**This package does not provide the ACCESS_FINE_LOCATION nor the ACCESS_COARSE_LOCATION permission by default.**

### iOS

**Use in simulators**

On iOS simulators wifi info will always return `null`.

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

#### iOS 14

Starting on iOS 14, the plugin uses the method `NEHotspotNetwork.fetchCurrentWithCompletionHandler` to obtain the WIFI SSID (name) and BSSID.

According to this method documentation:

```
 * @discussion This method returns SSID, BSSID and security type of the current Wi-Fi network when the
 *   requesting application meets one of following 4 requirements -.
 *   1. application is using CoreLocation API and has user's authorization to access precise location.
 *   2. application has used NEHotspotConfiguration API to configure the current Wi-Fi network.
 *   3. application has active VPN configurations installed.
 *   4. application has active NEDNSSettingsManager configuration installed.
 *   An application will receive nil if it fails to meet any of the above 4 requirements.
 *   An application will receive nil if does not have the "com.apple.developer.networking.wifi-info" entitlement.
 ```

**You will have to comply with ONE of the 4 conditions listed.**

The example application for this project, implements number 1 using the [permission_handler](https://pub.dev/packages/permission_handler) plugin.

Also, **your application needs the "com.apple.developer.networking.wifi-info" entitlement.**

This entitlement can be configured in xcode with the name "Access Wi-Fi information", and it is also found in the file `Runner.entitlements` in the example project. However, 
**this entitlement is only possible when using a professional development team** and not a "Personal development team".

Without complying with these conditions, the calls to `.getWifiBSSID()` and `.getWifiName()` will return null.

## Learn more

- [API Documentation](https://pub.dev/documentation/network_info_plus/latest/network_info_plus/network_info_plus-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/network_info_plus/overview)
