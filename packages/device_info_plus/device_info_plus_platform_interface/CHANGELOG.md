## 7.0.1

 - **FIX**(all): changed homepage url in pubspec.yaml ([#3099](https://github.com/fluttercommunity/plus_plugins/issues/3099)). ([66613656](https://github.com/fluttercommunity/plus_plugins/commit/66613656a85c176ba2ad337e4d4943d1f4171129))

## 7.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: refactor of device_info_plus platform implementation (#1293).

## 6.0.1

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 6.0.0

> Note: This release has breaking changes.

 - **FIX**: add `@Deprecated` annotation to `toMap` method (#1142).
 - **DOCS**: Add info about Android properties availability, update API docs links (#1243).
 - **BREAKING** **REFACTOR**: Change nullability for AndroidDeviceInfo properties (#1246).
 - **BREAKING** **REFACTOR**: two-package federated architecture (#1228).

## 5.0.0

> Note: This release has breaking changes.

 - **BREAKING** **FEAT**: Add support of Android display metrics (#829).

## 4.0.1

 - **CHORE**: Version tagging using melos.

## 4.0.0

- Re-introduce Windows: Add userName, majorVersion, minorVersion, buildNumber, platformId, csdVersion, servicePackMajor, servicePackMinor, suitMask, productType, reserved, buildLab, buildLabEx, digitalProductId, displayVersion, editionId, installDate, productId, productName, registeredOwner, releaseId, deviceId to WindowsDeviceInfo.

## 3.0.0

- Redo 2.6.0 into 3.0.0
- Remove `androidId` (that was removed in the MethodChannel, and always returned null)

## 2.6.1

- Revert 2.6.0

## 2.6.0

- Remove `androidId` (that was removed in the MethodChannel, and always returned null)

## 2.5.0

- Revert 2.4.0 changes

## 2.4.0

- Windows: Add userName, majorVersion, minorVersion, buildNumber, platformId, csdVersion, servicePackMajor, servicePackMinor, suitMask, productType, reserved, buildLab, buildLabEx, digitalProductId, displayVersion, editionId, installDate, productId, productName, registeredOwner, releaseId, deviceId to WindowsDeviceInfo.

## 2.3.0+1

- Fix LinuxDeviceInfo.name docs

## 2.3.0

- add `BaseDeviceInfo`

## 2.2.1

- add toMap to WebBrowserInfo

## 2.2.0

- add System GUID to MacOS

## 2.1.0

- add toMap to models

## 2.0.0

- WebBrowserInfo properties are now nullable

## 1.0.2

- Improve documentation

## 1.0.1

- Fix https://github.com/fluttercommunity/plus_plugins/issues/184: Null values on Android

## 1.0.0

- Migrated to null safety

## 0.4.0

- Add macOS support.

## 0.3.0

- Rename method channel to avoid conflicts.

## 0.2.0

- Transfer to plus-plugins monorepo

## 0.1.0

- Transfer package to Flutter Community under new name `device_info_plus_platform_interface`.

## 0.0.1

- Initial open-source release.
