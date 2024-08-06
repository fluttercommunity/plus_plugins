## 2.0.1

 - **FIX**(all): changed homepage url in pubspec.yaml ([#3099](https://github.com/fluttercommunity/plus_plugins/issues/3099)). ([66613656](https://github.com/fluttercommunity/plus_plugins/commit/66613656a85c176ba2ad337e4d4943d1f4171129))

## 2.0.0

> Note: This release has breaking changes.

 - **FIX**(connectivity_plus): Fix connectivity state update on Android when network is lost ([#2673](https://github.com/fluttercommunity/plus_plugins/issues/2673)). ([21191682](https://github.com/fluttercommunity/plus_plugins/commit/2119168267e436e5900ea09cf68dd110e51b01e0))
 - **FIX**(connectivity_plus): Return valid connection type when only one available ([#2668](https://github.com/fluttercommunity/plus_plugins/issues/2668)). ([81026a4c](https://github.com/fluttercommunity/plus_plugins/commit/81026a4c6c07cb610299a8f17db69c518475a675))
 - **BREAKING** **FEAT**(connectivity_plus): support multiple connectivity types at the same time ([#2599](https://github.com/fluttercommunity/plus_plugins/issues/2599)). ([5b477468](https://github.com/fluttercommunity/plus_plugins/commit/5b4774683d6e186fbd69cf4208302221f52aa54d))

## 1.2.4

 - **FIX**: Do not return ConnectivityResult.none on iOS and MacOS with VPN (#1335).

## 1.2.3

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 1.2.2

- Add missing VPN enum

## 1.2.1

- Update flutter_lints to 2.0.1
- Update plugin_platform_interface to 2.1.2
- Fix analyzer issues

## 1.2.0

- Add bluetooth as connectivity result

## 1.1.1

- Dependencies update

## 1.1.0

- Add ethernet as connectivity result

## 1.0.2

- Update connectivity plus

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
