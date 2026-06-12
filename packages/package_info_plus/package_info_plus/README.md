# package_info_plus

[![package_info_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/package_info_plus.yaml)
[![pub points](https://img.shields.io/pub/points/package_info_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/package_info_plus/score)
[![pub package](https://img.shields.io/pub/v/package_info_plus.svg)](https://pub.dev/packages/package_info_plus)

[<img src="../../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

This Flutter plugin provides an API for querying information about an application package.

## Platform Support

| Android |  iOS  | macOS |  Web  | Linux | Windows |
| :-----: | :---: | :---: | :---: | :---: | :-----: |
|✅|✅|✅|✅|✅|✅|

## Requirements

- Flutter >=3.38.1
- Dart >=3.10.0 <4.0.0
- iOS >=13.0
- macOS >=10.15
- Java 17
- Kotlin 2.2.0
- Android Gradle Plugin >=8.12.1
- Gradle wrapper >=8.13

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

### Installer Store

The `installerStore` property indicates which app store installed the application. This is useful for directing users to the appropriate store page for ratings or updates.

```dart
PackageInfo packageInfo = await PackageInfo.fromPlatform();
String? installerStore = packageInfo.installerStore;
```

#### iOS

On iOS, the `installerStore` value is determined by checking the app store receipt path:

| Environment | `installerStore` value |
|-------------|------------------------|
| App Store | `com.apple` |
| TestFlight | `com.apple.testflight` |
| Simulator | `com.apple.simulator` |

#### Android

On Android, the value is the package name of the app store that installed the application, obtained via `PackageManager.getInstallSourceInfo()` (Android 11+) or `PackageManager.getInstallerPackageName()` (older versions).

| Store | `installerStore` value |
|-------|------------------------|
| Google Play Store | `com.android.vending` |
| Amazon Appstore | `com.amazon.venezia` |
| Samsung Galaxy Store | `com.sec.android.app.samsungapps` |
| Huawei AppGallery | `com.huawei.appmarket` |
| Xiaomi GetApps | `com.xiaomi.mipicks` |
| OPPO App Market | `com.oppo.market` |
| VIVO App Store | `com.vivo.appstore` |
| Manual/ADB install | `null` |

**Note:** Some stores may not properly implement the installer package name API, which could result in `null` being returned even for store installations.

#### Other Platforms

On MacOS, Linux, Windows, and Web, `installerStore` returns `null`.

## Known Issues

### iOS

#### Plugin returns incorrect app version

Flutter build tools allow only digits and `.` (dot) symbols to be used in `version`
of `pubspec.yaml` on iOS/macOS to comply with official version format from Apple.

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
If your project was created before Flutter 3.3 you need to migrate the project according to [this guide](https://docs.flutter.dev/release/breaking-changes/windows-version-information) first to get correct version with `package_info_plus`

### Web

In a web environment, the package uses the `version.json` file that it is generated in the build process.

#### `version.json` reflects the deployed version, not the running one

`PackageInfo.fromPlatform()` resolves the version on web by fetching `version.json` from the server
at runtime (with a cache buster). That file reflects the **currently deployed** version, not the
version of the bundle actually executing in the browser. If a user is running a stale, cached bundle
while a newer version has been deployed, `fromPlatform()` reports the newly deployed version.
The fetch can also fail entirely (offline, CORS, hosting rewrites), leaving every field empty.

If you need the version of the *running* bundle — e.g. to display it to the user or to gate
outdated clients — use the compile-time accessor below instead.

#### Compile-time package information (`PackageInfoEnvironment`)

Import the opt-in `package_info_plus_environment.dart` library and read
`PackageInfoEnvironment.packageInfo`:

```dart
import 'package:package_info_plus/package_info_plus_environment.dart';

final info = await PackageInfoEnvironment.packageInfo;
```

Behaviour per platform:

- **Web** — returns a `PackageInfo` built from the compile-time `PACKAGE_INFO_PLUS_*` defines.
  These are embedded in the running bundle and cannot diverge from it. Provide them at build time:

  ```sh
  flutter build web \
    --dart-define=PACKAGE_INFO_PLUS_VERSION=1.2.3 \
    --dart-define=PACKAGE_INFO_PLUS_BUILD_NUMBER=45
  ```

  A **web build that omits `PACKAGE_INFO_PLUS_VERSION` fails to compile**, so a misleading version
  can never ship silently. `PACKAGE_INFO_PLUS_BUILD_NUMBER`, `PACKAGE_INFO_PLUS_APP_NAME` and
  `PACKAGE_INFO_PLUS_PACKAGE_NAME` are optional (empty when omitted).

- **All other platforms** — delegates to `PackageInfo.fromPlatform()`, which reads the installed
  binary and is already reliable. The defines are not required there.

The accessor also recognizes tool-provided defines as fallbacks, so apps need no configuration at
all once their build front-end injects the version itself: `FLUTTER_BUILD_NAME` /
`FLUTTER_BUILD_NUMBER` (proposed in [flutter/flutter#187935](https://github.com/flutter/flutter/pull/187935))
and `dart.package.version` ([dart-lang/sdk#38855](https://github.com/dart-lang/sdk/issues/38855)).
The explicit `PACKAGE_INFO_PLUS_*` defines take precedence over both.

`PackageInfo.fromPlatform()` is unchanged; this accessor lives in a separate library that you import
only when you opt in, so existing builds are unaffected.

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

