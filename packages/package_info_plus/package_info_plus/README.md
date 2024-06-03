# package_info_plus

[![package_info_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml)
[![pub points](https://img.shields.io/pub/points/package_info_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/package_info_plus/score)
[![pub package](https://img.shields.io/pub/v/package_info_plus.svg)](https://pub.dev/packages/package_info_plus)

[<img src="../../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

This Flutter plugin provides an API for querying information about an application package.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|✅|✅|✅|✅|

## Requirements

- Flutter >=3.3.0
- Dart >=2.18.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

## Usage

You can use the PackageInfo to query information about the application package. This works both on
iOS and Android.

```dart
import 'package:package_info_plus/package_info_plus.dart';

...

// Be sure to add this line if `PackageInfo.fromPlatform()` is called before runApp()
WidgetsFlutterBinding.ensureInitialized();

...

PackageInfo packageInfo = await PackageInfo.fromPlatform();

String appName = packageInfo.appName;
String packageName = packageInfo.packageName;
String version = packageInfo.version;
String buildNumber = packageInfo.buildNumber;
```

## Known Issues

### iOS

#### Plugin returns incorrect app version

Flutter build tools allow only digits and `.` (dot) symbols to be used in `version`
of `pubspec.yaml` on iOS/MacOS to comply with official version format from Apple.

More info available in [this comment](https://github.com/fluttercommunity/plus_plugins/issues/389#issuecomment-1106764429)

#### I have changed version in pubspec.yaml and plugin returns wrong info

As noted on [issue 20761](https://github.com/flutter/flutter/issues/20761#issuecomment-493434578),
package_info_plus on iOS requires the Xcode build folder to be rebuilt after changes to the version
string in `pubspec.yaml`. Clean the Xcode build folder with:
`XCode Menu -> Product -> (Holding Option Key) Clean build folder`.

### Android (and potentially all platforms)

Calling to `PackageInfo.fromPlatform()` before the `runApp()` call will cause an exception.
See https://github.com/fluttercommunity/plus_plugins/issues/309

### Windows

#### I see wrong version on Windows platform

There was an [issue](https://github.com/flutter/flutter/issues/73652) in Flutter, which is already resolved since Flutter 3.3.
If your project was created before Flutter 3.3 you need to migrate the project according to [this guide] (https://docs.flutter.dev/release/breaking-changes/windows-version-information) first to get correct version with `package_info_plus`

### Web

In a web environment, the package uses the `version.json` file that it is generated in the build process.

#### Accessing the `version.json`

The package tries to locate the `version.json` using three methods:

1. Using the provided `baseUrl` in the `fromPlatform()` method.
2. Checking the configured `assets` folder in the Flutter web configuration.
3. Checking the path where the application is installed.

See the documentation at the method `fromPlatform()` to learn more.

#### CORS `version.json` access

It could be possible that the plugin cannot access the `version.json` file because the server is preventing it.
This can be due a CORS issue, and it is known to happen when hosting the Flutter code on Firebase Hosting.
Ensure that your CORS Firebase configuration allows it.

## Learn more

- [API Documentation](https://pub.dev/documentation/package_info_plus/latest/package_info_plus/package_info_plus-library.html)

