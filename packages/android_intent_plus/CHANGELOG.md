## 4.0.3

 - **FIX**(android_intent_plus): Fix annotation dependency declaration ([#2237](https://github.com/fluttercommunity/plus_plugins/issues/2237)). ([795a3dd8](https://github.com/fluttercommunity/plus_plugins/commit/795a3dd81d8c718344936d65226d051f5fe4a125))
 - **FIX**(android_intent_plus): Revert bump compileSDK to 34 ([#2236](https://github.com/fluttercommunity/plus_plugins/issues/2236)). ([38bba0eb](https://github.com/fluttercommunity/plus_plugins/commit/38bba0ebc0f1db404a673440749e4d1d95dcf26c))

## 4.0.2

 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 4.0.1

 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))

## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(android_intent_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(android_intent_plus): Bump min Android version to 4.4 (API 19) (#1784).
 - **REFACTOR**(android_intent_plus): Update example app to use Material 3.

## 3.1.9

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.1.8

 - **FIX**(android_intent_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1699).

## 3.1.7

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.1.6

 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.1.5

 - **FIX**: lint warnings - add missing dependency for tests (#1233).

## 3.1.4

 - **DOCS**: Add documentation for canResolveActivity.

## 3.1.3

 - **CHORE**: Version tagging using melos.

## 3.1.2

- Fix explicit intent fallback to implicit
- Update Android Gradle plugin and Gradle verion

## 3.1.1+1

- Add issue_tracker link.

## 3.1.1

- Fix embedding issue in example
- Update Platform dependency to not use deprecated function

## 3.1.0

- Added `arrayArguments` to explicitly pass array values to an intent

## 3.0.2

- Fixed the buildIntent method to do not set the pacakage to null if it's not resolvable
- Updated the example of resolving intent with explicitly defined package name

## 3.0.1

- Upgrade dependencies and Android compile version
- Remove some leftover code of Android v1 embedding

## 3.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 2.1.0

- migrate integration_test to flutter sdk

## 2.0.0

- increase flutter SDK version to 1.20.0

## 1.0.3

- clean up ios folder
- rename channel name to dev.fluttercommunity.plus in java tests

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Null safety support.

## 0.4.2

- Add launchChooser method, which uses Intent.createChooser internally.
- Add sendBroadcast method, which uses context.sendBroadcast() internally.

## 0.4.1

- Renamed Method Channel and changed Java package to avoid collision with android_intent

## 0.4.0

- Transfer to plus-plugins monorepo

## 0.3.8

- Transfer package to Flutter Community under new name `android_intent_plus`.

## 0.3.7+2

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.3.7+1

- Fix CocoaPods podspec lint warnings.

## 0.3.7

- Add a `Future<bool> canResolveActivity` method to the AndroidIntent class. It
  can be used to determine whether a device supports a particular intent or has
  an app installed that can resolve it. It is based on PackageManager
  [resolveActivity](<https://developer.android.com/reference/android/content/pm/PackageManager#resolveActivity(android.content.Intent,%20int)>).

## 0.3.6+1

- Bump the minimum Flutter version to 1.12.13+hotfix.5.
- Bump the minimum Dart version to 2.3.0.
- Uses Darts spread operator to build plugin arguments internally.
- Remove deprecated API usage warning in AndroidIntentPlugin.java.
- Migrates the Android example to V2 embedding.

## 0.3.6

- Marks the `action` parameter as optional
- Adds an assertion to ensure the intent receives an action, component or both.

## 0.3.5+1

- Make the pedantic dev_dependency explicit.

## 0.3.5

- Add support for [setType](<https://developer.android.com/reference/android/content/Intent.html#setType(java.lang.String)>) and [setDataAndType](<https://developer.android.com/reference/android/content/Intent.html#setDataAndType(android.net.Uri,%20java.lang.String)>) parameters.

## 0.3.4+8

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.3.4+7

- Fix pedantic linter errors.

## 0.3.4+6

- Add missing DartDocs for public members.

## 0.3.4+5

- Remove AndroidX warning.

## 0.3.4+4

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.3.4+3

- Android: Use android.arch.lifecycle instead of androidx.lifecycle:lifecycle in `build.gradle` to support apps that has not been migrated to AndroidX.

## 0.3.4+2

- Fix resolveActivity not respecting the provided componentName.

## 0.3.4+1

- Fix minor lints in the Java platform code.
- Add smoke e2e tests for the V2 embedding.
- Fully migrate the example app to AndroidX.

## 0.3.4

- Migrate the plugin to use the V2 Android engine embedding. This shouldn't
  affect existing functionality. Plugin authors who use the V2 embedding can now
  instantiate the plugin and expect that it correctly responds to app lifecycle
  changes.

## 0.3.3+3

- Define clang module for iOS.

## 0.3.3+2

- Update and migrate iOS example project.

## 0.3.3+1

- Added "action_application_details_settings" action to open application info settings .

## 0.3.3

- Added "flags" option to call intent.addFlags(int) in native.

## 0.3.2

- Added "action_location_source_settings" action to start Location Settings Activity.

## 0.3.1+1

- Fix Gradle version.

## 0.3.1

- Add a new componentName parameter to help the intent resolution.

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

## 0.2.1

- Updated Gradle tooling to match Android Studio 3.1.2.

## 0.2.0

- **Breaking change**. Set SDK constraints to match the Flutter beta release.

## 0.1.1

- Simplified and upgraded Android project template to Android SDK 27.
- Updated package description.

## 0.1.0

- **Breaking change**. Upgraded to Gradle 4.1 and Android Studio Gradle plugin
  3.0.1. Older Flutter projects need to upgrade their Gradle setup as well in
  order to use this version of the plugin. Instructions can be found
  [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).

## 0.0.3

- Add FLT prefix to iOS types.

## 0.0.2

- Add support for transferring structured Dart values into Android Intent
  instances as extra Bundle data.

## 0.0.1

- Initial release
