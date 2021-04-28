## 1.0.1

- Improve documentation

## 1.0.0

- Migrated to null safety

## 0.4.1

- Address pub score

## 0.4.0

- Removed members that were moved to network_info_plus

## 0.3.0

- Renamed method channel

## 0.2.0

- Transfer to plus-plugins monorepo

## 0.1.7

- Transfer package to Flutter Community under new name `connectivity_plus_platform_interface`.

## 0.1.6

- Update lower bound of dart dependency to 2.1.0.

## 0.1.5

- Remove dart:io Platform checks from the MethodChannel implementation. This is
  tripping the analysis of other versions of the plugin.

## 0.1.4

- Bump the minimum Flutter version to 1.12.13+hotfix.5.

## 0.1.3

- Make the pedantic dev_dependency explicit.

## 0.1.2

- Bring ConnectivityResult and LocationAuthorizationStatus enums from the core package.
- Use the above Enums as return values for ConnectivityPlatformInterface methods.
- Modify the MethodChannel implementation so it returns the right types.
- Bring all utility methods, asserts and other logic that is only needed on the MethodChannel implementation from the core package.
- Bring MethodChannel unit tests from core package.

## 0.1.1

- Fix README.md link.

## 0.1.0

- Initial release.
