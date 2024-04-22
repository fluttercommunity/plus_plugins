## 6.0.3

 - **FIX**(connectivity_plus): Ensure Connectivity on Android is correctly reported when lost ([#2836](https://github.com/fluttercommunity/plus_plugins/issues/2836)). ([2aa6ad7a](https://github.com/fluttercommunity/plus_plugins/commit/2aa6ad7a1c05d35b894e6cef515bd9dfa49351dd))

## 6.0.2

 - **REFACTOR**(connectivity_plus): remove ReachabilityConnectivityProvider and ReachabilitySwift dependency ([#2813](https://github.com/fluttercommunity/plus_plugins/issues/2813)). ([f9ad927f](https://github.com/fluttercommunity/plus_plugins/commit/f9ad927f5c18f8ed8d4c22a24476430239c13492))
 - **REFACTOR**(connectivity_plus): Migrate Android example to use the new plugins declaration ([#2771](https://github.com/fluttercommunity/plus_plugins/issues/2771)). ([04200c23](https://github.com/fluttercommunity/plus_plugins/commit/04200c2311e8dd581980ed19f8ebd24d0afd1512))
 - **FIX**(connectivity_plus): WASM-compatible conditional imports ([#2825](https://github.com/fluttercommunity/plus_plugins/issues/2825)). ([6bee4a7e](https://github.com/fluttercommunity/plus_plugins/commit/6bee4a7e02d681ce94d8bd95c4399d844b0ceb27))
 - **FIX**(connectivity_plus): Improve iOS PathMonitorConnectivityProvider implementation and documentation ([#2763](https://github.com/fluttercommunity/plus_plugins/issues/2763)). ([c850d58e](https://github.com/fluttercommunity/plus_plugins/commit/c850d58ed9f422182c8f77583a43bcb13d5d979f))
 - **DOCS**(connectivity_plus): Document supported ConnectivityResult per platform ([#2780](https://github.com/fluttercommunity/plus_plugins/issues/2780)). ([1c4aec01](https://github.com/fluttercommunity/plus_plugins/commit/1c4aec019e74433a2b1174d75522b5abb0c9d9b4))
 - **DOCS**(connectivity_plus): Update README for more clarity ([#2770](https://github.com/fluttercommunity/plus_plugins/issues/2770)). ([8fb738e2](https://github.com/fluttercommunity/plus_plugins/commit/8fb738e2b8f5534db8f1c0fbbeae1a51cf03d099))
 - **DOCS**(connectivity_plus): Specify behavior when there is no connectivity ([#2753](https://github.com/fluttercommunity/plus_plugins/issues/2753)). ([8f132a23](https://github.com/fluttercommunity/plus_plugins/commit/8f132a23a0424299c5e9b946171164bc66710540))
 - **DOCS**(connectivity_plus): Improve documentation onConnectivityChanged method ([#2746](https://github.com/fluttercommunity/plus_plugins/issues/2746)). ([9ea21fbd](https://github.com/fluttercommunity/plus_plugins/commit/9ea21fbdbb9974077375f803f5bb3c57abcb6488))

## 6.0.1

> Note: This release has breaking changes.

> Plugin now requires the following:
> - Flutter >=3.19.0
> - Dart >=3.3.0
> - compileSDK 34 for Android part
> - Java 17 for Android part
> - Gradle 8.4 for Android part

In this release plugin migrated to package:web, meaning that it now supports WASM!

- **BREAKING** **FEAT**(connectivity_plus): support multiple connectivity types at the same time ([#2599](https://github.com/fluttercommunity/plus_plugins/issues/2599)). ([5b477468](https://github.com/fluttercommunity/plus_plugins/commit/5b4774683d6e186fbd69cf4208302221f52aa54d))
- **BREAKING** **FEAT**(connectivity_plus): Migrate to package:web ([#2621](https://github.com/fluttercommunity/plus_plugins/issues/2621)). ([fbc8e61c](https://github.com/fluttercommunity/plus_plugins/commit/fbc8e61c4f8996d6ba47622de191a83dc2fe1882))
- **BREAKING** **BUILD**(connectivity_plus): Target Java 17 on Android ([2413e45e](https://github.com/fluttercommunity/plus_plugins/commit/2413e45e88fa6a431c29f8e6240780e20c405453))
- **BREAKING** **BUILD**(connectivity_plus): Update to target and compile SDK 34 ([#2701](https://github.com/fluttercommunity/plus_plugins/pull/2701)). ([7ddd749](https://github.com/fluttercommunity/plus_plugins/commit/7ddd74989d2921af706f5e7a1aa32e41159ce13f))
- **BREAKING** **REFACTOR**(connectivity_plus): bump MACOSX_DEPLOYMENT_TARGET from 10.11 to 10.14 ([#2588](https://github.com/fluttercommunity/plus_plugins/issues/2588)). ([f6fe62d5](https://github.com/fluttercommunity/plus_plugins/commit/f6fe62d5f4d87c93e0f974e96bbd47ff453937d9))
- **FIX**(connectivity_plus): Emit event with types on Android when subscribing to onConnectivityChanged ([#2721](https://github.com/fluttercommunity/plus_plugins/issues/2721)). ([5a81e7ef](https://github.com/fluttercommunity/plus_plugins/commit/5a81e7ef75d75852935f7a095e5b426d534edff9))
- **FIX**(connectivity_plus): Fix connectivity state update on Android when network is lost ([#2673](https://github.com/fluttercommunity/plus_plugins/issues/2673)). ([21191682](https://github.com/fluttercommunity/plus_plugins/commit/2119168267e436e5900ea09cf68dd110e51b01e0))
- **FIX**(connectivity_plus): Return valid connection type when only one available ([#2668](https://github.com/fluttercommunity/plus_plugins/issues/2668)). ([81026a4c](https://github.com/fluttercommunity/plus_plugins/commit/81026a4c6c07cb610299a8f17db69c518475a675))
- **FIX**(connectivity_plus): Add iOS Privacy Info ([#2581](https://github.com/fluttercommunity/plus_plugins/issues/2581)). ([707fab70](https://github.com/fluttercommunity/plus_plugins/commit/707fab70eb1dd262226158be97586a67eec03dd0))
- **FIX**(connectivity_plus): Fix iOS example app name ([#2722](https://github.com/fluttercommunity/plus_plugins/issues/2722)). ([2441accd](https://github.com/fluttercommunity/plus_plugins/commit/2441accdffc3bc86f5e74db6c682d0dd4fbd6813))
- **DOCS**(connectivity_plus): Update documentation to address API changes ([#2719](https://github.com/fluttercommunity/plus_plugins/issues/2719)). ([59b9b341](https://github.com/fluttercommunity/plus_plugins/commit/59b9b3417cd0387d8a5f9e857eb350b4048dc68c))

## 6.0.0

> Note: DO NOT USE THIS RELEASE. It is invalid due to a publishing issue

## 5.0.2

 - **FIX**(connectivity_plus): Return correct connection state on Linux ([#2371](https://github.com/fluttercommunity/plus_plugins/issues/2371)). ([26576d83](https://github.com/fluttercommunity/plus_plugins/commit/26576d838be3b39121fd77ab33f49fc1fff1a97f))

## 5.0.1

 - **FIX**(connectivity_plus): Fix CHANGELOG to not mention Kotlin requirement ([#2246](https://github.com/fluttercommunity/plus_plugins/issues/2246)). ([e489d4aa](https://github.com/fluttercommunity/plus_plugins/commit/e489d4aa7a223b152b89b6c33ae994e8a73679bd))

## 5.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**(connectivity_plus): Bump min iOS to 12 to not crash after builds with Xcode 15 ([#2169](https://github.com/fluttercommunity/plus_plugins/issues/2169)). ([cf7d93fb](https://github.com/fluttercommunity/plus_plugins/commit/cf7d93fbfc76830acf2db755543cf4235a49df60))
 - **FIX**(connectivity_plus): Revert bump compileSDK to 34 ([#2229](https://github.com/fluttercommunity/plus_plugins/issues/2229)). ([01df65ce](https://github.com/fluttercommunity/plus_plugins/commit/01df65ce0268093de5dd381c84d251668dc95984))
 - **FEAT**(connectivity_plus): Remove deprecated VALID_ARCHS iOS property ([#2021](https://github.com/fluttercommunity/plus_plugins/issues/2021)). ([ee89d583](https://github.com/fluttercommunity/plus_plugins/commit/ee89d5836c7e598fce07d89e82a2d127ddfacbf8))


## 4.0.2

 - **FIX**(connectivity_plus): Downgrade js version to work with Flutter 3.3.10 ([#1989](https://github.com/fluttercommunity/plus_plugins/issues/1989)). ([42938c0c](https://github.com/fluttercommunity/plus_plugins/commit/42938c0c03132f7f50fa047c2970660d2720d320))
 - **FIX**(connectivity_plus): Regenerate iOS and MacOS example apps ([#1874](https://github.com/fluttercommunity/plus_plugins/issues/1874)). ([fc22e54e](https://github.com/fluttercommunity/plus_plugins/commit/fc22e54ec166d37d4326a9271677054fd34ccc3c))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 4.0.1

 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))

## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(connectivity_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(connectivity_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1782).

## 3.0.6

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.0.5

 - **FIX**(connectivity_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1701).

## 3.0.4

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **DOCS**(connectivity_plus): Documentation added for the missing network interface enums (#1524).

## 3.0.3

 - **FIX**: Do not return ConnectivityResult.none on iOS and MacOS with VPN (#1335).
 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.2

 - **FIX**: Add connectivity_plus_web export (#1278).

## 3.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.0

> Note: This release has breaking changes.

 - **FIX**: lint warnings - add missing dependency for tests (#1233).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1227).

## 2.3.9

 - **CHORE**: Version tagging using melos.

## 2.3.8

- Discard unused warnings for `ensurePathMonitor` & `ensureReachability` call in iOS.

## 2.3.7

- iOS: Reduce compiler warnings

## 2.3.6+1

- Add issue_tracker link.

## 2.3.6

- Web: Fix Bad state: Stream has already been listened to (#943)

## 2.3.5

- Stop sending events once flutter engine detached on iOS/macOS (#865)

## 2.3.4

- Disables internal use of `NetworkInformationAPI` which is still experimental

## 2.3.3

- macOS: Send events on main thread

## 2.3.2

- iOS: Send events on main thread (#846)

## 2.3.1

- Update flutter_lints to 2.0.1
- Update dev dependencies

## 2.3.0

- Add iOS ConnectivityProvider based on NWPathMonitor for iOS 12+.

## 2.2.2

- Reachability.swift ".unavailable" for iOS is deprecated.

## 2.2.1

- Bump `nm` plugin to 0.5.0 (connectivity_plus_linux)
- Fix embedding issue in example

## 2.2.0

- Add bluetooth as connectivity result. Supported on Android, Linux, and Web

## 2.1.0

- Migrated iOS plugin to Swift
- Removed dependency to old Reachability pod
- Added dependency to Reachability.swift pod

## 2.0.3

- Add Gradle wrapper to Android plugin

## 2.0.2

- Fix for error: lambda expressions are not supported in -source 7

## 2.0.1

- Upgrade Android compile SDK version
- Several code improvements

## 2.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 1.4.0

- [MacOS]: Backport to macOS 10.11

## 1.3.0

- Add ethernet as connectivity result. Supported on Android, iOS, Windows, Linux, macOS, and Web

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.0

- Add ethernet as connectivity result. Supported on Android, Linux, macOS, and Web

## 1.0.8

- Web: Fix to show `ConnectivityResult.mobile` instead of `ConnectivityResult.wifi` when the network is connected to 4g

## 1.0.7

- Android: Fix to detect no-network when Wi-Fi is disconnected on Android M and above

## 1.0.6

- Android: Fix unregisterReceiver call for API < N

## 1.0.5

- Android: Fix memory leak from registered receiver
- Android: Fix gradle crash due to previous update in version 1.0.4

## 1.0.4

- Android: Add explicit compiler version to avoid warnings

## 1.0.3

- Android: migrate to mavenCentral

## 1.0.2

- Fix ios bug https://github.com/fluttercommunity/plus_plugins/issues/198
- Update android https://github.com/fluttercommunity/plus_plugins/issues/62
- Update Web class naming conflict https://github.com/fluttercommunity/plus_plugins/issues/260

## 1.0.1

- Improve documentation

## 1.0.0

- Migrated to null safety

## 0.8.1

- Address pub score

## 0.8.0

- Add Windows support (`connectivity_plus_windows`).
- Removed members that were moved to network_info_plus

## 0.7.2

- Deprecated the following members (use network_info_plus instead):
  - getWifiBSSID()
  - getWifiIP()
  - requestLocationServiceAuthorization()
  - getLocationServiceAuthorization()

## 0.7.1

- Bump linux version.

## 0.7.0

- Add Linux support (`connectivity_plus_linux`).

## 0.6.0

- Fix issue #56: Rename Android and iOS classes and Method Channel to avoid
  collision with the original connectivity package.

## 0.5.0

- Transfer to plus-plugins monorepo

## 0.4.9+2

- Update package:e2e to use package:integration_test

## 0.4.9+1

- Update package:e2e reference to use the local version in the flutter/plugins
  repository.

## 0.4.9

- Add support for `web` (by endorsing `connectivity_for_web` 0.3.0)

## 0.4.8+6

- Update lower bound of dart dependency to 2.1.0.

## 0.4.8+5

- Declare API stability and compatibility with `1.0.0` (more details at: https://github.com/flutter/flutter/wiki/Package-migration-to-1.0.0).

## 0.4.8+4

- Bump the minimum Flutter version to 1.12.13+hotfix.5.
- Clean up various Android workarounds no longer needed after framework v1.12.
- Complete v2 embedding support.
- Fix CocoaPods podspec lint warnings.

## 0.4.8+3

- Replace deprecated `getFlutterEngine` call on Android.

## 0.4.8+2

- Remove hard coded ios workspace setting of the example app.

## 0.4.8+1

- Make the pedantic dev_dependency explicit.

## 0.4.8

- Adds macOS as an endorsed platform.

## 0.4.7

- Migrate the plugin to use the ConnectivityPlatform.instance defined in the connectivity_plus_platform_interface package.

## 0.4.6+2

- Migrate deprecated BinaryMessages to ServicesBinding.instance.defaultBinaryMessenger.
- Bump Flutter SDK to 1.12.13+hotfix.5 or greater (current stable).

## 0.4.6+1

- Remove the deprecated `author:` field from pubspec.yaml
- Migrate the plugin to the pubspec platforms manifest.
- Require Flutter SDK 1.10.0 or greater.

## 0.4.6

- Add macOS support.

## 0.4.5+8

- Update documentation to explain when connectivity updates are received on Android.

## 0.4.5+7

- Fix unawaited futures in the example app and tests.

## 0.4.5+6

- Fix singleton Reachability problem on iOS.

## 0.4.5+5

- Add an analyzer check for the public documentation.

## 0.4.5+4

- Stability and Maintainability: update documentations.

## 0.4.5+3

- Remove AndroidX warnings.

## 0.4.5+2

- Include lifecycle dependency as a compileOnly one on Android to resolve
  potential version conflicts with other transitive libraries.

## 0.4.5+1

- Android: Use android.arch.lifecycle instead of androidx.lifecycle:lifecycle in `build.gradle` to support apps that has not been migrated to AndroidX.

## 0.4.5

- Support the v2 Android embedder.

## 0.4.4+1

- Update and migrate iOS example project.
- Define clang module for iOS.

## 0.4.4

- Add `requestLocationServiceAuthorization` to request location authorization on iOS.
- Add `getLocationServiceAuthorization` to get location authorization status on iOS.
- Update README: add more information on iOS 13 updates with CNCopyCurrentNetworkInfo.

## 0.4.3+7

- Update README with the updated information about CNCopyCurrentNetworkInfo on iOS 13.

## 0.4.3+6

- [Android] Fix the invalid suppression check (it should be "deprecation" not "deprecated").

## 0.4.3+5

- [Android] Added API 29 support for `check()`.
- [Android] Suppress warnings for using deprecated APIs.

## 0.4.3+4

- [Android] Updated logic to retrieve network info.

## 0.4.3+3

- Support for TYPE_MOBILE_HIPRI on Android.

## 0.4.3+2

- Add missing template type parameter to `invokeMethod` calls.

## 0.4.3+1

- Fixes lint error by using `getApplicationContext()` when accessing the Wifi Service.

## 0.4.3

- Add getWifiBSSID to obtain current wifi network's BSSID.

## 0.4.2+2

- Add integration test.

## 0.4.2+1

- Bump the minimum Flutter version to 1.2.0.
- Add template type parameter to `invokeMethod` calls.

## 0.4.2

- Adding getWifiIP() to obtain current wifi network's IP.

## 0.4.1

- Add unit tests.

## 0.4.0+2

- Log a more detailed warning at build time about the previous AndroidX
  migration.

## 0.4.0+1

- Updated `Connectivity` to a singleton.

## 0.4.0

- **Breaking change**. Migrate from the deprecated original Android Support
  Library to AndroidX. This shouldn't result in any functional changes, but it
  requires any Android apps using this plugin to [also
  migrate](https://developer.android.com/jetpack/androidx/migrate) if they're
  using the original support library.

## 0.3.2

- Adding getWifiName() to obtain current wifi network's SSID.

## 0.3.1

- Updated Gradle tooling to match Android Studio 3.1.2.

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

- Add FLT prefix to iOS types.

## 0.1.0

- Breaking API change: Have a Connectivity class instead of a top level function
- Introduce ability to listen for network state changes

## 0.0.1

- Initial release
