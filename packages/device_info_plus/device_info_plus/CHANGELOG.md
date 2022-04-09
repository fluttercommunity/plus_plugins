## 3.2.3

- Add support for Android display metrics

## 3.2.2

- Fix embedding issue in example
- Update Android dependencies in example

## 3.2.1

- iOS: fix `identifierForVendor` (can be `null` in rare circumstances)
- Use automatic plugin registration on Linux and Windows
- Fix warnings when building for macOS

## 3.2.0

- add `deviceInfo`

## 3.1.1

- add toMap to WebBrowserInfo

## 3.1.0

- add System GUID to MacOS

## 3.0.1

- Upgrade Android compile SDK version
- Several code improvements

## 3.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 2.2.0

- migrate integration_test to flutter sdk

## 2.1.0

- add toMap to models

## 2.0.1

- Android: migrate to mavenCentral

## 2.0.0

- WebBrowserInfo properties are now nullable

## 1.0.1

- Improve documentation

## 1.0.0

- Migrated to null safety
- Update dependencies.

## 0.7.2

- Update dependencies.

## 0.7.1

- Fix macOS support.

## 0.7.0

- Add macOS support via `device_info_plus_macos`.

## 0.6.0

- Rename method channel to avoid conflicts.

## 0.5.0

- Transfer to plus-plugins monorepo

## 0.4.2+8

- Transfer package to Flutter Community under new name `device_info_plus`.

## 0.4.2+7

- Port device_info plugin to use platform interface.

## 0.4.2+6

- Moved everything from device_info to device_info/device_info

## 0.4.2+5

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.2+4

Update lower bound of dart dependency to 2.1.0.

## 0.4.2+3

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.4.2+2

- Fix CocoaPods podspec lint warnings.

## 0.4.2+1

- Bump the minimum Flutter version to 1.12.13+hotfix.5.
- Remove deprecated API usage warning in AndroidIntentPlugin.java.
- Migrates the Android example to V2 embedding.
- Bumps AGP to 3.6.1.

## 0.4.2

- Add systemFeatures to AndroidDeviceInfo.

## 0.4.1+5

- Make the pedantic dev_dependency explicit.

## 0.4.1+4

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.4.1+3

- Fix pedantic errors. Adds some missing documentation and fixes unawaited
  futures in the tests.

## 0.4.1+2

- Remove AndroidX warning.

## 0.4.1+1

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.4.1

- Support the v2 Android embedding.
- Update to AndroidX.
- Migrate to using the new e2e test binding.
- Add a e2e test.

## 0.4.0+4

- Define clang module for iOS.

## 0.4.0+3

- Update and migrate iOS example project.

## 0.4.0+2

- Bump minimum Flutter version to 1.5.0.
- Add missing template type parameter to `invokeMethod` calls.
- Replace invokeMethod with invokeMapMethod wherever necessary.

## 0.4.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.4.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.3.0

- Added ability to get Android ID for Android devices

## 0.2.1

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.1.2

- Fixed Dart 2 type errors.

## 0.1.1

- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.5

- Added FLT prefix to iOS types

## 0.0.4

- Fixed Java/Dart communication error with empty lists

## 0.0.3

- Added support for utsname

## 0.0.2

- Fixed broken type comparison
- Added "isPhysicalDevice" field, detecting emulators/simulators

## 0.0.1

- Implements platform-specific device/OS properties
