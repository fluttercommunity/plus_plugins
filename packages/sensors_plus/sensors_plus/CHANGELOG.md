## 5.0.0

> Note: This release has breaking changes.

In this release plugin migrated migrated from dart:html to js_interop, meaning that it now supports WASM!

Plugin now requires the following:
- Flutter >=3.19.0
- Dart >=3.3.0
- compileSDK 34 for Android part
- Java 17 for Android part
- Gradle 8.4 for Android part

 - **BREAKING** **FEAT**(sensors_plus): Migrate to dart:js_interop ([#2697](https://github.com/fluttercommunity/plus_plugins/issues/2697)). ([48edfa20](https://github.com/fluttercommunity/plus_plugins/commit/48edfa20558530cd08a55a880a42f3d080ccbe94))
 - **BREAKING** **BUILD**(sensors_plus): Target Java 17 on Android ([#2729](https://github.com/fluttercommunity/plus_plugins/issues/2729)). ([7a83e355](https://github.com/fluttercommunity/plus_plugins/commit/7a83e3558db7c8d4d217a485ef9a5b0c1ed7039a))
 - **BREAKING** **BUILD**(sensors_plus): Update to target and compile SDK 34 ([#2708](https://github.com/fluttercommunity/plus_plugins/pull/2708)). ([f110dfd](https://github.com/fluttercommunity/plus_plugins/commit/f110dfdd87f9de4346e8f9f765c0f05e0a02d1fa))
 - **FIX**(sensors_plus): Add try-catch for release builds ([#2718](https://github.com/fluttercommunity/plus_plugins/issues/2718)). ([c37acd67](https://github.com/fluttercommunity/plus_plugins/commit/c37acd671801e6ebb1249b2ce1939799ea27b6fb))
 - **FIX**(sensors_plus): Add iOS Privacy Info ([#2585](https://github.com/fluttercommunity/plus_plugins/issues/2585)). ([9b7198a9](https://github.com/fluttercommunity/plus_plugins/commit/9b7198a91ed2778a1399a9152441bea7fa75bf6e))
 - **FEAT**(sensors_plus): Update min iOS target to 12 ([#2661](https://github.com/fluttercommunity/plus_plugins/issues/2661)). ([ca5d660f](https://github.com/fluttercommunity/plus_plugins/commit/ca5d660f8cb7350f7c364b9c91a377c21f7dd0a1))

## 4.0.2

 - **FIX**(sensors_plus): Close magnetometerStreamController on web ([#2456](https://github.com/fluttercommunity/plus_plugins/issues/2456)). ([64200667](https://github.com/fluttercommunity/plus_plugins/commit/64200667e94ec6eedeb3f8224f355d113dee3ac8))

## 4.0.1+1

 - **DOCS**(sensors_plus): Update README to mention how sampling rate works on Android ([#2452](https://github.com/fluttercommunity/plus_plugins/issues/2452)). ([4d8ce2f8](https://github.com/fluttercommunity/plus_plugins/commit/4d8ce2f8e9eb09e8ae6e5616599a593ff182ea24))

## 4.0.1

> Note: This release has breaking changes.

 - **BREAKING** **FIX**(sensors_plus): Use magnetometer instead of deviceMotion on iOS ([#2250](https://github.com/fluttercommunity/plus_plugins/issues/2250)). ([d1751024](https://github.com/fluttercommunity/plus_plugins/commit/d175102404f5a614360dc52380e95aa0a6308481))
 - **FEAT**(sensors_plus): Configurable sample rate on Android and iOS ([#2248](https://github.com/fluttercommunity/plus_plugins/issues/2248)). ([82ffe46c](https://github.com/fluttercommunity/plus_plugins/commit/82ffe46c6ff02a7fcaad35c74c872e1ceb37621c))
 - **DOCS**(sensors_plus): Add info about sensors sampling rate configuration ([#2393](https://github.com/fluttercommunity/plus_plugins/issues/2393)). ([35900ead](https://github.com/fluttercommunity/plus_plugins/commit/35900eadd91e88d5eb2d28eeb32048edbb1057c9))

## 4.0.0

This release was retracted due to [#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251).

## 3.1.0

> Info: This release is a replacement for release 4.0.0, which was retracted due to issue ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)). As breaking change was reverted the major release was also reverted in favor of this one.

 - **FIX**(sensors_plus): Change Kotlin version from 1.9.10 to 1.7.22 ([#2253](https://github.com/fluttercommunity/plus_plugins/issues/2253)). ([10fade07](https://github.com/fluttercommunity/plus_plugins/commit/10fade073928e2676e6383e0697ba0d123ab4a87))
 - **FIX**(sensors_plus): Close stream controllers onCancel on web ([#2249](https://github.com/fluttercommunity/plus_plugins/issues/2249)). ([476e17bc](https://github.com/fluttercommunity/plus_plugins/commit/476e17bc7e404862dafc5eb57c57908181f3f52f))
 - **FIX**(sensors_plus): Revert bump compileSDK to 34 ([#2233](https://github.com/fluttercommunity/plus_plugins/issues/2233)). ([8574422a](https://github.com/fluttercommunity/plus_plugins/commit/8574422aad07955e6a2bad7863f557c7ae0a1d57))
 - **FIX**(sensors_plus): Error handling of native crashes (e.g. missing hardware) ([#1987](https://github.com/fluttercommunity/plus_plugins/issues/1987)). ([ee942290](https://github.com/fluttercommunity/plus_plugins/commit/ee9422901bc16a5e6e183f918646865336646955))
 - **FEAT**(sensors_plus): Remove deprecated VALID_ARCHS iOS property ([#2027](https://github.com/fluttercommunity/plus_plugins/issues/2027)). ([8ba4197e](https://github.com/fluttercommunity/plus_plugins/commit/8ba4197ee4258f56984e69d4c1196c234ed3dce0))

## 3.0.3

 - **FIX**(sensors_plus): fixed the deprecated syntax ([#1904](https://github.com/fluttercommunity/plus_plugins/issues/1904)). ([57f06352](https://github.com/fluttercommunity/plus_plugins/commit/57f06352ccf0c6aec0f483cb595764826623e311))
 - **FIX**(sensors_plus): Regenerate iOS example app ([#1870](https://github.com/fluttercommunity/plus_plugins/issues/1870)). ([5046f542](https://github.com/fluttercommunity/plus_plugins/commit/5046f542433726534a2fb1c06c85f8bfc5f41398))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 3.0.2

 - **FIX**(sensors_plus): Fix issues with emitting multiple sensors events on iOS ([#1859](https://github.com/fluttercommunity/plus_plugins/issues/1859)). ([d33b20fa](https://github.com/fluttercommunity/plus_plugins/commit/d33b20fa7c76368dbcc12064df8469c301658b53))

## 3.0.1

 - **FIX**(sensors_plus): Fix crash on Android if device has no requested sensor ([#1405](https://github.com/fluttercommunity/plus_plugins/issues/1405)). ([a078b4e8](https://github.com/fluttercommunity/plus_plugins/commit/a078b4e8464a3b8dce24ee5112394097d981a173))
 - **FIX**: Add jvm target compatibility to Kotlin plugins ([#1798](https://github.com/fluttercommunity/plus_plugins/issues/1798)). ([1b7dc432](https://github.com/fluttercommunity/plus_plugins/commit/1b7dc432ffb8d0474c9be6339d20b5a2cbcbab3f))
 - **DOCS**(sensor_plus): Add info about possible error cases ([#1830](https://github.com/fluttercommunity/plus_plugins/issues/1830)). ([58d512de](https://github.com/fluttercommunity/plus_plugins/commit/58d512de24f9f4eeb154375958378868fd4bb1a7))
 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))
 - **CHORE**(sensors_plus): Win32 dependency upgrade ([#1805](https://github.com/fluttercommunity/plus_plugins/pull/1805)). ([3f68800](https://github.com/fluttercommunity/plus_plugins/commit/c8f7b6342a7c51eafafae95792775505d2b52ce9))

## 3.0.0

> Note: This release has breaking changes.

 - **CHORE**(sensors_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(sensors_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1774).
 - **REFACTOR**(sensors_plus): Remove manual dependency_override in example app.

## 2.0.5

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 2.0.4

 - **FIX**(sensors_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1705).

## 2.0.3

 - **DOCS**(sensor_plus): improve description of accelerometer (#1425).

## 2.0.2

 - **DOCS**: Updates for READMEs and website pages (#1389).

## 2.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 2.0.0

> Note: This release has breaking changes.

 - **FIX**: lint warnings - add missing dependency for tests (#1233).
 - **DOCS**: Update website docs and README (#1247).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1237).

## 1.4.1

 - **CHORE**: Version tagging using melos.

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
