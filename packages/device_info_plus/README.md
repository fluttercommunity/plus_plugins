# device_info_plus

[![Flutter Community: device_info_plus](https://fluttercommunity.dev/_github/header/device_info_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/device_info_plus.svg)](https://pub.dev/packages/device_info_plus)

Get current device information from within the Flutter application.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Window |
|:-------:|:---:|:-----:|:---:|:-----:|:------:|
|    ✔️    |  ✔️  |   ✔️   |  ✔️  |   ✔️   |        |

# Usage

Import `package:device_info_plus/device_info.dart`, instantiate `DeviceInfoPlugin`
and use the Android and iOS, Web getters to get platform-specific device
information.

Example:

```dart
import 'package:device_info_plus/device_info_plus.dart';

DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
print('Running on ${androidInfo.model}');  // e.g. "Moto G (4)"

IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"

WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
print('Running on ${webBrowserInfo.userAgent}');  // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
```

You will find links to the API docs on the [pub page](https://pub.dev/packages/device_info_plus).

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.dev/).

For help on editing plugin code, view the [documentation](https://flutter.dev/platform-plugins/#edit-code).
