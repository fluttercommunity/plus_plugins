## 6.1.3

 - **FIX**(network_info_plus): Improve Wi-Fi IP address retrieval on iOS to avoid null ([#3408](https://github.com/fluttercommunity/plus_plugins/issues/3408)). ([7c8894b9](https://github.com/fluttercommunity/plus_plugins/commit/7c8894b99878ccbcc33845f9d19e0921470d5935))

## 6.1.2

 - **REFACTOR**(all): Use range of flutter_lints for broader compatibility ([#3371](https://github.com/fluttercommunity/plus_plugins/issues/3371)). ([8a303add](https://github.com/fluttercommunity/plus_plugins/commit/8a303add3dee1acb8bac5838246490ed8a0fe408))

## 6.1.1

 - **FIX**(network_info_plus): Update privacy manifest path on MacOS ([#3350](https://github.com/fluttercommunity/plus_plugins/issues/3350)). ([18c81efd](https://github.com/fluttercommunity/plus_plugins/commit/18c81efd0b9f510023c481965b5868184d435961))

## 6.1.0

 - **FEAT**(network_info_plus): Add Swift Package Manager support ([#3172](https://github.com/fluttercommunity/plus_plugins/issues/3172)). ([bcf7a5bb](https://github.com/fluttercommunity/plus_plugins/commit/bcf7a5bbd06d667cc6a4390c7cb79c349bdce6c7))

## 6.0.2

 - **FIX**(all): Clean up macOS Privacy Manifests ([#3268](https://github.com/fluttercommunity/plus_plugins/issues/3268)). ([d7b98ebd](https://github.com/fluttercommunity/plus_plugins/commit/d7b98ebd7d39b0143931f5cc6e627187576223dc))
 - **FIX**(all): Add macOS Privacy Manifests ([#3251](https://github.com/fluttercommunity/plus_plugins/issues/3251)). ([bf5dad2a](https://github.com/fluttercommunity/plus_plugins/commit/bf5dad2ad249605055bcbd5f663e42569df12d64))

## 6.0.1

 - **FIX**(network_info_plus): Avoid usage of unsupported package:win32 versions ([#3179](https://github.com/fluttercommunity/plus_plugins/issues/3179)). ([79f61add](https://github.com/fluttercommunity/plus_plugins/commit/79f61add195693f33330103dd5f31f6433dfc1f2))

## 6.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FIX**(network_info_plus): Do not ignore errors on Android ([#3080](https://github.com/fluttercommunity/plus_plugins/issues/3080)). ([5b0cdf4f](https://github.com/fluttercommunity/plus_plugins/commit/5b0cdf4f71a8cc21b245c7defe355ec7b5796cc2))
 - **REFACTOR**(all): Remove website files, configs, mentions ([#3018](https://github.com/fluttercommunity/plus_plugins/issues/3018)). ([ecc57146](https://github.com/fluttercommunity/plus_plugins/commit/ecc57146aa8c6b1c9c332169d3cc2205bc4a700f))
 - **FIX**(all): changed homepage url in pubspec.yaml ([#3099](https://github.com/fluttercommunity/plus_plugins/issues/3099)). ([66613656](https://github.com/fluttercommunity/plus_plugins/commit/66613656a85c176ba2ad337e4d4943d1f4171129))

## 5.0.3

 - **REFACTOR**(network_info_plus): Migrate Android example to use the new plugins declaration ([#2768](https://github.com/fluttercommunity/plus_plugins/issues/2768)). ([d7206929](https://github.com/fluttercommunity/plus_plugins/commit/d72069292995355fbe0fe62ec6d74f34005008f6))
 - **DOCS**(network_info_plus): Add explanation on Wi-Fi name in quotes to README ([#2815](https://github.com/fluttercommunity/plus_plugins/issues/2815)). ([e94c9b4b](https://github.com/fluttercommunity/plus_plugins/commit/e94c9b4be566f99dba34718fc2b4868165d31026))

## 5.0.2

> Plugin now requires the following:
> - compileSDK 34 for Android part
> - Java 17 for Android part
> - Gradle 8.4 for Android part

- **BREAKING** **REFACTOR**(network_info_plus): bump MACOSX_DEPLOYMENT_TARGET from 10.11 to 10.14 ([#2590](https://github.com/fluttercommunity/plus_plugins/issues/2590)). ([4033e162](https://github.com/fluttercommunity/plus_plugins/commit/4033e1623de7836893a672098936c218ee9f7aca))
- **BREAKING** **FEAT**(network_info_plus): Remove deprecated permission handling methods, update example and docs ([#2686](https://github.com/fluttercommunity/plus_plugins/issues/2686)). ([a71a27c5](https://github.com/fluttercommunity/plus_plugins/commit/a71a27c5fbdbbfc56a30359a1aff0a3d3da8dc73))
- **BREAKING** **BUILD**(network_info_plus): Target Java 17 on Android ([#2726](https://github.com/fluttercommunity/plus_plugins/issues/2726)). ([5eaa3a7d](https://github.com/fluttercommunity/plus_plugins/commit/5eaa3a7d3ed47ced0a452f7604066d030490d379))
- **BREAKING** **BUILD**(network_info_plus): Update to target and compile SDK 34 ([#2706](https://github.com/fluttercommunity/plus_plugins/pull/2706)). ([efb3bac](https://github.com/fluttercommunity/plus_plugins/commit/efb3bace46a1e71f4d4fef1d0de67c4195183bf3))
- **FIX**(network_info_plus): Added getWifiIPv6, getWifiSubmask, getWifiBroadcast and getWifiGatewayIP functions for Windows and fixed getWifiName and getWifiBSSID. ([#2666](https://github.com/fluttercommunity/plus_plugins/issues/2666)). ([915a4431](https://github.com/fluttercommunity/plus_plugins/commit/915a44312b796b10ad65995e0297d7cd23b37cd0))
- **FIX**(network_info_plus): Add iOS Privacy Info ([#2583](https://github.com/fluttercommunity/plus_plugins/issues/2583)). ([3b0cd6c3](https://github.com/fluttercommunity/plus_plugins/commit/3b0cd6c38e0b736a903c69cf6e3df8e40a37815f))
- **FEAT**(network_info_plus): Update min iOS target to 12 ([#2659](https://github.com/fluttercommunity/plus_plugins/issues/2659)). ([c01d6012](https://github.com/fluttercommunity/plus_plugins/commit/c01d60120556449c4df5ce74d0f0941f4f8bc061))
- **DOCS**(network_info_plus): Add note about ios simulators ([#2524](https://github.com/fluttercommunity/plus_plugins/issues/2524)). ([20a7515e](https://github.com/fluttercommunity/plus_plugins/commit/20a7515ead6ffbae02be0b1a5cba91c93bf5c84f))

## 5.0.1

> Note: DO NOT USE THIS RELEASE. It is invalid due to a publishing issue

## 5.0.0

> Note: This release was retracted due to ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)).

## 4.1.0+1

 - **DOCS**(network_info_plus): Add note about ios simulators ([#2524](https://github.com/fluttercommunity/plus_plugins/issues/2524)). ([20a7515e](https://github.com/fluttercommunity/plus_plugins/commit/20a7515ead6ffbae02be0b1a5cba91c93bf5c84f))

## 4.1.0

> Info: This release is a replacement for release 5.0.0, which was retracted due to issue ([#2251](https://github.com/fluttercommunity/plus_plugins/issues/2251)). As breaking change was reverted the major release was also reverted in favor of this one.

 - **FIX**(network_info_plus): Change Kotlin version from 1.9.10 to 1.7.22 ([#2255](https://github.com/fluttercommunity/plus_plugins/issues/2255)). ([2454eac1](https://github.com/fluttercommunity/plus_plugins/commit/2454eac19e08a7e03d7890ce56a97ce8707a5fbb))
 - **FIX**(network_info_plus): Revert bump compileSDK to 34 ([#2231](https://github.com/fluttercommunity/plus_plugins/issues/2231)). ([0c600ee5](https://github.com/fluttercommunity/plus_plugins/commit/0c600ee5fa0a0075ccd7446ad81857ed0855143d))
 - **FIX**(network_info_plus): Return nullable values on windows again ([#2101](https://github.com/fluttercommunity/plus_plugins/issues/2101)). ([ab6e6b52](https://github.com/fluttercommunity/plus_plugins/commit/ab6e6b52ff456fa4b6f8c5a8e2cf7df5a1dd1f4e))
 - **FEAT**(network_info_arm): Remove deprecated VALID_ARCHS iOS property ([#2026](https://github.com/fluttercommunity/plus_plugins/issues/2026)). ([5a20b5a7](https://github.com/fluttercommunity/plus_plugins/commit/5a20b5a7127670e37630d255b6f716777807ebe6))

## 4.0.2

 - **FIX**(network_info_plus): Regenerate iOS and MacOS example apps ([#1872](https://github.com/fluttercommunity/plus_plugins/issues/1872)). ([c9da2612](https://github.com/fluttercommunity/plus_plugins/commit/c9da2612801f26b943b2822be2baef0e695fdb02))
 - **DOCS**(all): Fix example links on pub.dev ([#1863](https://github.com/fluttercommunity/plus_plugins/issues/1863)). ([d726035a](https://github.com/fluttercommunity/plus_plugins/commit/d726035ad7631d5a1397d0a2e5df23dc7e30a4f7))

## 4.0.1

 - **FIX**: Add jvm target compatibility to Kotlin plugins ([#1798](https://github.com/fluttercommunity/plus_plugins/issues/1798)). ([1b7dc432](https://github.com/fluttercommunity/plus_plugins/commit/1b7dc432ffb8d0474c9be6339d20b5a2cbcbab3f))
 - **DOCS**(all): Update READMEs ([#1828](https://github.com/fluttercommunity/plus_plugins/issues/1828)). ([57d9c884](https://github.com/fluttercommunity/plus_plugins/commit/57d9c8845edfc81fdbabcef9eb1d1ca450e62e7d))
 - **CHORE**(network_info_plus): Win32 dependency upgrade ([#1823](https://github.com/fluttercommunity/plus_plugins/pull/1823)). ([11b5c24](https://github.com/fluttercommunity/plus_plugins/commit/11b5c24e958adae089c285d585159844ef4d34dc))

## 4.0.0

> Note: This release has breaking changes.

 - **CHORE**(network_info_plus): Update Flutter dependencies, set Flutter >=3.3.0 and Dart to >=2.18.0 <4.0.0
 - **BREAKING** **FIX**(all): Add support of namespace property to support Android Gradle Plugin (AGP) 8 (#1727). Projects with AGP < 4.2 are not supported anymore. It is highly recommended to update at least to AGP 7.0 or newer.
 - **BREAKING** **CHORE**(network_info_plus): Bump min Android to 4.4 (API 19) and iOS to 11, update podspec file (#1777).
 - **REFACTOR**(network_info_plus): Rewrite Windows implementation in Dart (#1780).

## 3.0.5

 - **FIX**(all): Revert addition of namespace to avoid build fails on old AGPs (#1725).

## 3.0.4

 - **FIX**(network_info_plus): Type cast for Linux when calling getWifiIP() (#1717).
 - **FIX**(network_info_plus): Add compatibility with AGP 8 (Android Gradle Plugin) (#1703).

## 3.0.3

 - **REFACTOR**(all): Remove all manual dependency_overrides (#1628).
 - **FIX**(network_info_plus): import original `getgateway.*` from libnatpmp (#1592).
 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.0.2

 - **DOCS**: Updates for READMEs and website pages (#1389).

## 3.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.0.0

> Note: This release has breaking changes.

 - **FIX**: lint warnings - add missing dependency for tests (#1233).
 - **FIX**: Get SSID on Android 12 and newer (#1231).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1235).

## 2.3.2

 - **FIX**: Mark iOS-specific permission methods as deprecated and update docs (#1155).

## 2.3.1

 - **CHORE**: Version tagging using melos.

## 2.3.0

- Android: Use new APIs to get network info on devices with with Android 12 (SDK 31) and newer. Due
  to this change on such devices be sure to add `ACCESS_NETWORK_STATE` permission into your
  `AndroidManifest.xml` file.

## 2.2.0

- Android: Migrate to Kotlin
- Android: Bump targetSDK to 33 (Android 13)
- Android: Update dependencies, build config updates
- Android: Fixed getWifiBroadcast to not add redundant `/` symbol
- Update Flutter dependencies

## 2.1.4+1

- Add issue_tracker link.

## 2.1.4

- Android: Plugin no longer removes `"` from SSID name.

## 2.1.3

- Update nm dependency to be compatible with fresh versions of other Plus plugins
- Set min Flutter version to 1.20.0 for all platforms

## 2.1.2

- Update Flutter dependencies

## 2.1.1

- Fix issue with getWifiInterface on iOS. See PR #605 for more info.

## 2.1.0

- macOS: Add submask, broadcast, gateway info

## 2.0.2

- Upgrade Android compile SDK version
- Several code improvements
- Remove remaining embedding v1 components

## 2.0.1

- Add IP v6 to MacOS

## 2.0.0

- Remove deprecated method `registerWith` (of Android v1 embedding)

## 1.3.0

- IOS: Use `NEHotspotNetwork` on iOS 14+ to get SSID/BSSID.

## 1.2.1

- IOS: Fix issue failed to build on iOS emulator

## 1.2.0

- migrate integration_test to flutter sdk

## 1.1.0

- Android, IOS: Adding IPv6 information
- Android, IOS: Adding gateway ip address information
- Android, IOS: Adding broadcast information
- Android, IOS: Adding subnet mask information

## 1.0.2

- Android: migrate to mavenCentral

## 1.0.1

- Improve documentation

## 1.0.0

- Migrate to null-safety.

## 0.1.2

- Address pub score.

## 0.1.1+1

- Provide longer package description to address pub score.

## 0.1.1

- Added a stub plugin for Web that throws unsupported exceptions, because the functionality is not
  supported on Web.

## 0.1.0

- Initial release
