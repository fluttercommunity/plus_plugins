## 5.0.1

> Note: This release has breaking changes.

 - **BREAKING** **FIX**(package_info_plus): Allow no page extension in versionJsonUrl on web ([#2381](https://github.com/fluttercommunity/plus_plugins/issues/2381)). ([32652b87](https://github.com/fluttercommunity/plus_plugins/commit/32652b8750245207240e383690e3b434149b87d0))
 - **BREAKING**(package_info_plus): Bump min Dart to 3.2.0 and min Flutter to 3.6.0 to support pkg:web ([#2316](https://github.com/fluttercommunity/plus_plugins/issues/2316)). ([450aeb57](https://github.com/fluttercommunity/plus_plugins/commit/450aeb578db80a9c7fb473cea133dbc87a68e530))
 - **FEAT**(package_info_plus): Migrate to pkg:web from dart:html. ([#2316](https://github.com/fluttercommunity/plus_plugins/issues/2316)). ([450aeb57](https://github.com/fluttercommunity/plus_plugins/commit/450aeb578db80a9c7fb473cea133dbc87a68e530))

## 5.0.0

> Note: This release was retracted due to ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)).

## 4.2.0

> Info: This release is a replacement for release 5.0.0, which was retracted due to issue ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)). As breaking change was reverted the major release was also reverted in favor of this one.

 - **FIX**(package_info_plus): Change Kotlin version from 1.9.10 to 1.7.22 ([#2254](https://github.com/fluttercommunity/plus_plugins/issues/2254)). ([885a2a1f](https://github.com/fluttercommunity/plus_plugins/commit/885a2a1fa086f19ca8d9effaaea22272d1a8260a))
 - **FIX**(package_info_plus): Revert bump compileSDK to 34 ([#2232](https://github.com/fluttercommunity/plus_plugins/issues/2232)). ([e25e3902](https://github.com/fluttercommunity/plus_plugins/commit/e25e3902a0353baa929a269e4440e4ff0ef7efac))
 - **FEAT**(package_info_plus): Remove deprecated VALID_ARCHS iOS property ([#2023](https://github.com/fluttercommunity/plus_plugins/issues/2023)). ([4e172576](https://github.com/fluttercommunity/plus_plugins/commit/4e1725762b98070ef6d8b90aea55ca35580ac349))
 - **DOCS**(package_info_plus): Add explanation for known issue on Windows ([#2029](https://github.com/fluttercommunity/plus_plugins/issues/2029)). ([87457bf4](https://github.com/fluttercommunity/plus_plugins/commit/87457bf437465e32f8bb5a340b3c4f33fbc0a5b4))

## 4.1.0

 - **FIX**(package_info_plus): proper version.json url for files with special characters ([#2015](https://github.com/fluttercommunity/plus_plugins/issues/2015)). ([235ee391](https://github.com/fluttercommunity/plus_plugins/commit/235ee391b87e9fa06ffc6c12a8fcdb1f6b446ca5))
 - **FIX**(package_info_plus): not working in Windows release mode from network location ([#1931](https://github.com/fluttercommunity/plus_plugins/issues/1931)). ([784caca5](https://github.com/fluttercommunity/plus_plugins/commit/784caca5b373b2ed95a76a256499bd2ae0b6fe41))
 - **FIX**(package_info_plus): Regenerate iOS and MacOS example apps ([#1871](https://github.com/fluttercommunity/plus_plugins/issues/1871)). ([0102fbbd](https://github.com/fluttercommunity/plus_plugins/commit/0102fbbdd096b23c802c31de69ec0bb08141645e))
 - **FEAT**(package_info_plus): Added toMap method ([#1926](https://github.com/fluttercommunity/plus_plugins/issues/1926)). ([4696ff45](https://github.com/fluttercommunity/plus_plugins/commit/4696ff450c4c1a84b43ba5ef3453265bdd569ada))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 4.0.2

- **CHORE**(package_info_plus): Update http dependency constraints (#1851)([#1851](https://github.com/fluttercommunity/plus_plugins/pull/1851)). ([1463bea](https://github.com/fluttercommunity/plus_plugins/commit/1463bea77b79ee1460798b9f65d2a467023b2e38))

## 4.0.1

 - **FIX**(package_info_plus): Get Windows package info when app is on a network drive ([#1697](https://github.com/fluttercommunity/plus_plugins/issues/1697)). ([d7f9c28b](https://github.com/fluttercommunity/plus_plugins/commit/d7f9c28b20842b882b5e196bc3d1ce7963067db6))
 - **FIX**: Add jvm target compatibility to Kotlin plugins ([#1798](https://github.com/fluttercommunity/plus_plugins/issues/1798)). ([1b7dc432](https://github.com/fluttercommunity/plus_plugins/commit/1b7dc432ffb8d0474c9be6339d20b5a2cbcbab3f))
 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))
 - **CHORE**(package_info_plus): Win32 dependency upgrade ([#1805](https://github.com/fluttercommunity/plus_plugins/pull/1805)). ([3f68800](https://github.com/fluttercommunity/plus_plugins/commit/c8f7b6342a7c51eafafae95792775505d2b52ce9))

## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(package_info_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(package_info_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1776).
 - **REFACTOR**(package_info_plus): Tidy up Windows implementation (#1768).
 - **DOCS**(package_info_plus): Explain why buildNumber returns version when no build number defined (#1729).

## 3.1.2

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.1.1

 - **FIX**(package_info_plus): remove html file parts from version url (#1330).
 - **FIX**(package_info_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1704).

## 3.1.0

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(package_info_plus): Make example app content scrollable (#1614).
 - **FIX**(package_info_plus): Make installerStore an optional argument in mocks (#1547).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).
 - **FEAT**(package_info_plus): Use new API to get install source on Android >= 11 (#1616).

## 3.0.3

 - **REFACTOR**: Remove nullable struct fields (#1526).
 - **DOCS**: Fixed markdown table formatting in README (#1477).
 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.2

 - **FIX**: adds value equality for PackageInfo (#1328).

## 3.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**: two-package federated architecture (#1236).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1228).

## 2.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Add information about the installer store (#1135).

## 1.4.3+1

- Add issue_tracker link.

## 1.4.3

- Windows: Updated package_info_plus_windows to version 2.0.0.
- MacOS: Updated package_info_plus_macos to 1.3.0.
- Updated test to 1.21.1.
- Updated flutter_lints to 2.0.1.

## 1.4.2

- Web: Resolve package_name
- Linux: Resolve package_name

## 1.4.1

- Windows: Fix MissingPluginException
- Linux: Fix MissingPluginException

## 1.4.0

- Android: Migrate to Kotlin
- Android: Update dependencies, build config updates
- Android: Fix project title

## 1.3.1

- Fix embedding issue in example

## 1.3.0

- Removed deprecated embeddingV1 function
- Upgraded gradle and Android API version

## 1.2.1

- Windows: Annotate int with external in preparation of Flutter 2.5

## 1.2.0

- fix app name on iOS and macOS

## 1.1.0

- migrate integration_test to flutter sdk

## 1.0.6

- Web: Fixed url resolving for the version.json

## 1.0.5

- Remove the `required` keyword of `buildSignature` in `PackageInfo`'s constructor to restore backward compatibility

## 1.0.4

- Add `buildSignature` to Android package info to retrieve the signing certifiate SHA1 at runtime.

## 1.0.3

- Android: migrate to mavenCentral

## 1.0.2

- Add cache buster to version.json

## 1.0.1

- Improve documentation

## 1.0.0

- Migrate to null-safety
- Update dependencies
- Fix dart SDK constraints

## 0.6.4

- Add support for mock data during tests

## 0.6.3

- Fix base URI resolving for Web
- Fix platform interface dependency version for Linux

## 0.6.2

- Fix collision with package_info

## 0.6.1

- Fix package dependencies with the windows and web plugins

## 0.6.0

- Changed method channel name
- Moved Java files to different java package to avoid issues with package_info

## 0.5.0

- Transfer to plus-plugins monorepo

## 0.4.5

- package_info_plus now supports web platform and now uses package_info_platform_interface.

## 0.4.4

- Transfer package to Flutter Community under new name `package_info_plus`.

## 0.4.3

- Update package:e2e -> package:integration_test

## 0.4.2

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.1

- Add support for macOS.

## 0.4.0+18

- Update lower bound of dart dependency to 2.1.0.

## 0.4.0+17

- Bump the minimum Flutter version to 1.12.13+hotfix.5.
- Clean up various Android workarounds no longer needed after framework v1.12.
- Complete v2 embedding support.
- Fix CocoaPods podspec lint warnings.

## 0.4.0+16

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.4.0+15

- Replace deprecated `getFlutterEngine` call on Android.

## 0.4.0+14

- Make the pedantic dev_dependency explicit.

## 0.4.0+13

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.4.0+12

- Fix pedantic lints. This involved internally refactoring how the
  `PackageInfo.fromPlatform` code handled futures, but shouldn't change existing
  functionality.

## 0.4.0+11

- Remove AndroidX warnings.

## 0.4.0+10

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.4.0+9

- Android: Use android.arch.lifecycle instead of androidx.lifecycle:lifecycle in `build.gradle` to support apps that has not been migrated to AndroidX.

## 0.4.0+8

- Support the v2 Android embedder.
- Update to AndroidX.
- Add a unit test.
- Migrate to using the new e2e test binding.

## 0.4.0+7

- Update and migrate iOS example project.
- Define clang module for iOS.

## 0.4.0+6

- Fix Android compiler warnings.

## 0.4.0+5

- Add iOS-specific warning to README.md.

## 0.4.0+4

- Add missing template type parameter to `invokeMethod` calls.
- Bump minimum Flutter version to 1.5.0.
- Replace invokeMethod with invokeMapMethod wherever necessary.

## 0.4.0+3

- Add integration test.

## 0.4.0+2

- Android: Using new method for BuildNumber in new android versions

## 0.4.0+1

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.4.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.3.2+1

- Fixed a crash on IOS when some of the package infos are not available.

## 0.3.2

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.3.1

- Added `appName` field to `PackageInfo` for getting the display name of the app.

## 0.3.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.2.1

- Fixed Dart 2 type error.

## 0.2.0

- **Breaking change**. Introduced class `PackageInfo` in place of individual functions.
- `PackageInfo` provides all package information with a single async call.

## 0.1.1

- Added package name to available information.
- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.2

- Add FLT prefix to iOS types

## 0.0.1

- Initial release
