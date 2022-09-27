## 1.4.0

- iOS: Corrects magnetometer implementation, returning calibrated values from
  `DeviceMotion` sensor rather than raw sensor samples
  
## 1.3.4+1

- Add issue_tracker link.

## 1.3.4

- Additonal fixes for crash issue: "Error: Sending a message before the FlutterEngine has been run."

## 1.3.3

- Fix: "crash on iOS: Sending a message before the FlutterEngine has been run"

## 1.3.2

- Fix: Android no longer crashes when app is closed if streams weren't listened to
- Update flutter_lints to 2.0.1
- Fix analyzer warnings

## 1.3.1

- Fix: unregister listeners on Android in `onDetachFromEngine` to not receive sensors events after app was killed

## 1.3.0

- Android: Migrate to Kotlin
- Android: Update dependencies, build config updates

## 1.2.2

- Fix example embedding issues

## 1.2.1

- Upgrade Android compile SDK version
- Several code improvements

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.0

- Adds magnetometer support

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Migrated to null-safety

## 0.6.0

- Renamed Method Channel

## 0.5.0

- Transfer to plus-plugins monorepo

## 0.4.2+5

- Transfer package to Flutter Community under new name `sensors_plus`.

## 0.4.2+4

- Update package:e2e -> package:integration_test

## 0.4.2+3

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.2+2

- Post-v2 Android embedding cleanup.

## 0.4.2+1

- Update lower bound of dart dependency to 2.1.0.

## 0.4.2

- Remove Android dependencies fallback.
- Require Flutter SDK 1.12.13+hotfix.5 or greater.
- Fix CocoaPods podspec lint warnings.

## 0.4.1+10

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.4.1+9

- Replace deprecated `getFlutterEngine` call on Android.

## 0.4.1+8

- Make the pedantic dev_dependency explicit.

## 0.4.1+7

- Fixed example userAccelerometerEvent in documentation

## 0.4.1+6

- Migrate from deprecated BinaryMessages to ServicesBinding.instance.defaultBinaryMessenger.
- Require Flutter SDK 1.12.13+hotfix.5 or greater (current stable).

## 0.4.1+5

- Fix example `setState()` called after `dispose()` by canceling the timer.

## 0.4.1+4

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.4.1+3

- Improve documentation and add unit test coverage.

## 0.4.1+2

- Remove AndroidX warnings.

## 0.4.1+1

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.4.1

- Support the v2 Android embedder.
- Update to AndroidX.
- Migrate to using the new e2e test binding.
- Add a e2e test.

## 0.4.0+3

- Update and migrate iOS example project.
- Define clang module for iOS.

## 0.4.0+2

- Suppress deprecation warning for BinaryMessages. See: https://github.com/flutter/flutter/issues/33446

## 0.4.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.4.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.3.5

- Added missing test package dependency.

## 0.3.4

- Make sensors Dart 2 compliant.

## 0.3.3

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.3.2

- Added user acceleration sensor events (i.e. accelerometer without gravity).

## 0.3.1

- Fixed Dart 2 type error with iOS sensor events.

## 0.3.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.2.1

- Fixed warnings from the Dart 2.0 analyzer.
- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.2.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.1.1

- Added FLT prefix to iOS types.

## 0.1.0

- Initial Open Source release.
