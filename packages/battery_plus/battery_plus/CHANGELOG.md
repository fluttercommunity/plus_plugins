## 5.0.2

 - **FIX**(battery_plus): Return correct state enum value on Android for not charging state ([#2451](https://github.com/fluttercommunity/plus_plugins/issues/2451)). ([68ddda39](https://github.com/fluttercommunity/plus_plugins/commit/68ddda39f0fa8e7ac950c13721403d49d0d97a65))

## 5.0.1

> Note: This release has breaking changes. There is a new state for battery available on Android, MacOS and Linux platforms.
> Also, MacOS implementation was updated to provide more accurate battery status. Be sure to test if it affects your MacOS app.

 - **BREAKING** **FIX**(battery_plus): Implement not_charging battery state ([#2275](https://github.com/fluttercommunity/plus_plugins/issues/2275)). ([6595e035](https://github.com/fluttercommunity/plus_plugins/commit/6595e035fd113b4a75651c9d471cc098d5798de3))
 - **BREAKING** **FEAT**(battery_plus): Introduce connected_not_charging state on MacOS ([#2399](https://github.com/fluttercommunity/plus_plugins/issues/2399)). ([78f44bf4](https://github.com/fluttercommunity/plus_plugins/commit/78f44bf41a7e8349240bacae2dd70598ba22e97a))
 - **BREAKING** **FEAT**(battery_plus): Introduce not_charging state on Linux ([#2400](https://github.com/fluttercommunity/plus_plugins/issues/2400)). ([42ef02bd](https://github.com/fluttercommunity/plus_plugins/commit/42ef02bd6de219fef1b2d9db2eebe9775a6ac751))
 - **DOCS**(battery_plus): Improve documentation on battery states ([#2402](https://github.com/fluttercommunity/plus_plugins/issues/2402)). ([baeb886f](https://github.com/fluttercommunity/plus_plugins/commit/baeb886fcc587f72662ce177ab4922496bb1db46))
 - **BREAKING** **FIX**(battery_plus): Bump iOS min target to 12 and update example app ([#2401](https://github.com/fluttercommunity/plus_plugins/issues/2401)). ([25ef7928](https://github.com/fluttercommunity/plus_plugins/commit/25ef7928cd57ca17d6107ed839711ea166d451a6))

## 5.0.0

This release was retracted due to due to ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)).

## 4.1.0

> Info: This release is a replacement for release 5.0.0, which was retracted due to issue ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)). As breaking change was reverted the major release was also reverted in favor of this one.

 - **FIX**(battery_plus): Change Kotlin version from 1.9.10 to 1.7.22 ([#2257](https://github.com/fluttercommunity/plus_plugins/issues/2257)). ([f5244e36](https://github.com/fluttercommunity/plus_plugins/commit/f5244e368c74d8b6e7bdd0062a4a2250dcabe540))
 - **FIX**(battery_plus): Revert bump of compileSDK to 34 ([#2228](https://github.com/fluttercommunity/plus_plugins/issues/2228)). ([e834f582](https://github.com/fluttercommunity/plus_plugins/commit/e834f582b85d5fb5a18aefc49b11b039ae600c78))
 - **FEAT**(battery_plus): Remove deprecated VALID_ARCHS iOS property ([#2025](https://github.com/fluttercommunity/plus_plugins/issues/2025)). ([09318317](https://github.com/fluttercommunity/plus_plugins/commit/0931831758dfc829e5649d880a616840a9b1d21f))

## 4.0.2

 - **FIX**(battery_plus): Regenerate iOS and MacOS example apps ([#1873](https://github.com/fluttercommunity/plus_plugins/issues/1873)). ([18deeff3](https://github.com/fluttercommunity/plus_plugins/commit/18deeff3c68f312e2dae0de80273e1991ef97f45))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 4.0.1

 - **FIX**(battery_plus): Use ContextCompat on Android to register broadcast receiver ([#1811](https://github.com/fluttercommunity/plus_plugins/issues/1811)). ([b901615c](https://github.com/fluttercommunity/plus_plugins/commit/b901615cdc12d4bc5140ba9713d16f5a85fa6198))
 - **FIX**: Add jvm target compatibility to Kotlin plugins ([#1798](https://github.com/fluttercommunity/plus_plugins/issues/1798)). ([1b7dc432](https://github.com/fluttercommunity/plus_plugins/commit/1b7dc432ffb8d0474c9be6339d20b5a2cbcbab3f))
 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))

## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(battery_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(battery_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1783).
 - **REFACTOR**(battery_plus): Update example app to use Material 3.
 - **FIX**(battery_plus): Close StreamController on Web and Linux when done (#1744).

## 3.0.6

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.0.5

 - **FIX**(battery_plus): Huawei power save mode check (#1708).
 - **FIX**(battery_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1700).

## 3.0.4

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.0.3

 - **FIX**: broadcast stream (#1479).
 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.2

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.1

 - **FIX**: lint warnings - add missing dependency for tests (#1233).

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: platform implementation refactor into a single package (#1169).

## 2.2.2

 - **FIX**: batteryState always return unknown on API < 26 (#1120).

## 2.2.1

- Fix: batteryState always return unknown on API < 26

## 2.2.0

- Android: Migrate to Kotlin
- Android: Bump targetSDK to 33 (Android 13)
- Android: Update dependencies, build config updates
- Update Flutter dependencies

## 2.1.4+1

- Add issue_tracker link.

## 2.1.4

- Update flutter_lints to 2.0.1
- Update dev dependencies

## 2.1.3

- Update battery_plus_linux dependency
- Set min Flutter version to 1.20.0 for all platforms

## 2.1.2

- Fix embedding issue in example
- (Android) Update Kotlin and Gradle plugin

## 2.1.1

- (Android) Fix null pointer exception in `isInBatterySaveMode()` on Samsung devices with One UI

## 2.1.0

- Add batteryState getter

## 2.0.2

- Update Flutter dependencies

## 2.0.1

- Upgrade Android compile SDK version
- Several code improvements

## 2.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.1

- Fix: Add break statements for unknown battery state in Android and iOS implementations

## 1.1.0

- Android, iOS, Windows : add getter for power save mode state

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Migrate to null safety

## 0.10.1

- Address pub score

## 0.10.0

- Added "unknown" battery state for batteryless systems.

## 0.9.1

- Send initial battery status for Android

## 0.9.0

- Add Linux support (`battery_plus_linux`)
- Add macOS support (`battery_plus_macos`)
- Add Windows support (`battery_plus_windows`)
- Rename method channel to avoid conflicts

## 0.8.0

- Transfer to plus-plugins monorepo

## 0.7.0

- Battery Plus supports web.

## 0.6.0

- Implement Battery Plus based on new `BatteryPlatformInterface`.

## 0.5.4

- Transfer package to Flutter Community under new name `batter_plus`.

## 0.5.3

- Update package:e2e to use package:integration_test

## 0.5.2

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.1

- Update lower bound of dart dependency to 2.1.0.

## 0.3.1+10

- Update minimum Flutter version to 1.12.13+hotfix.5
- Fix CocoaPods podspec lint warnings.

## 0.3.1+9

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.3.1+8

- Make the pedantic dev_dependency explicit.

## 0.3.1+7

- Clean up various Android workarounds no longer needed after framework v1.12.

## 0.3.1+6

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.3.1+5

- Fix pedantic linter errors.

## 0.3.1+4

- Update and migrate iOS example project.

## 0.3.1+3

- Remove AndroidX warning.

## 0.3.1+2

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.3.1+1

- Android: Use android.arch.lifecycle instead of androidx.lifecycle:lifecycle in `build.gradle` to support apps that has not been migrated to AndroidX.

## 0.3.1

- Support the v2 Android embedder.

## 0.3.0+6

- Define clang module for iOS.

## 0.3.0+5

- Fix Gradle version.

## 0.3.0+4

- Update Dart code to conform to current Dart formatter.

## 0.3.0+3

- Fix `batteryLevel` usage example in README

## 0.3.0+2

- Bump the minimum Flutter version to 1.2.0.
- Add template type parameter to `invokeMethod` calls.

## 0.3.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.3.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.2.3

- Updated mockito dependency to 3.0.0 to get Dart 2 support.
- Update test package dependency to 1.3.0, and fixed tests to match.

## 0.2.2

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.1

- Fixed Dart 2 type error.
- Removed use of deprecated parameter in example.

## 0.2.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.1.1

- Fixed warnings from the Dart 2.0 analyzer.
- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.2

- Add FLT prefix to iOS types.

## 0.0.1+1

- Updated README

## 0.0.1

- Initial release
