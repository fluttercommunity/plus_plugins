# package_info_plus

[![Flutter Community: package_info_plus](https://fluttercommunity.dev/_github/header/package_info_plus)](https://github.com/fluttercommunity/community)

[![package_info_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml)
[![pub points](https://img.shields.io/pub/points/package_info_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/package_info_plus/score)
[![pub package](https://img.shields.io/pub/v/package_info_plus.svg)](https://pub.dev/packages/package_info_plus)

<p class="center">
<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>
</p>

This Flutter plugin provides an API for querying information about an application package.

## Platform Support

| Android |  iOS  | MacOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|✅|✅|✅|✅|

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

## Learn more

- [API Documentation](https://pub.dev/documentation/package_info_plus/latest/package_info_plus/package_info_plus-library.html)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/package_info_plus/overview/)

