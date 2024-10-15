## 5.0.1

 - **FIX**(share_plus): `mime` compatible with v2 (v1 still supported) ([#3309](https://github.com/fluttercommunity/plus_plugins/issues/3309)). ([401db75e](https://github.com/fluttercommunity/plus_plugins/commit/401db75efa24c40fd96a05e79d12801f92666efd))

## 5.0.0

> Note: This release has breaking changes.

 - **FIX**(all): changed homepage url in pubspec.yaml ([#3099](https://github.com/fluttercommunity/plus_plugins/issues/3099)). ([66613656](https://github.com/fluttercommunity/plus_plugins/commit/66613656a85c176ba2ad337e4d4943d1f4171129))
 - **BREAKING** **FEAT**(share_plus): Introduce optional parameter `nameOverride` to `shareXFiles`. ([#3077](https://github.com/fluttercommunity/plus_plugins/issues/3077)). ([f483bce7](https://github.com/fluttercommunity/plus_plugins/commit/f483bce77f50fc03e8c6c969864dd978e46f32da))

## 4.0.0

> Note: This release has breaking changes.

 - **BREAKING** **REFACTOR**(share_plus): Share API cleanup ([#2832](https://github.com/fluttercommunity/plus_plugins/issues/2832)). ([fd0511ca](https://github.com/fluttercommunity/plus_plugins/commit/fd0511ca4d55db1e075e72af5a0832b5cfe81244))

## 3.4.0

 - **FIX**(share_plus): add sharePositionOrigin parameter to shareUri ([#2517](https://github.com/fluttercommunity/plus_plugins/issues/2517)). ([f896d94e](https://github.com/fluttercommunity/plus_plugins/commit/f896d94e6c24551d9dc7d73d8fb05a0f283e0e83))
 - **FEAT**(share_plus): Use XFile.name whenever possible, shorten UUID filenames, and improve I/O throughput ([#2713](https://github.com/fluttercommunity/plus_plugins/issues/2713)). ([734321b8](https://github.com/fluttercommunity/plus_plugins/commit/734321b82d51fc3201113a6ca645c9bebb0282a2))

## 3.3.1

 - chore(deps): bump uuid from 3.0.7 to 4.0.0

## 3.3.0

 - **FEAT**(share_plus): Allow user to share URI with preview image on the iOS native share sheet ([#1779](https://github.com/fluttercommunity/plus_plugins/issues/1779)). ([c83b667e](https://github.com/fluttercommunity/plus_plugins/commit/c83b667eb12394feef69221eda0eab8716aa19d8))

## 3.2.1

 - **FIX**(all): Fix depreciations for flutter 3.7 and 2.19 dart (#1529).

## 3.2.0

 - **FIX**: export XFile (#1286).
 - **FEAT**: share XFile created using File.fromData() (#1284).

## 3.1.2

 - **FIX**: Increase min Flutter version to fix dartPluginClass registration (#1275).

## 3.1.1

- Add missing dart:ui import

## 3.1.0

- Add `shareXFiles` implementations
- Deprecate `shareFiles*` implementations
- Enable `shareXFiles` implementations on Web

## 3.0.3

- Update dependencies

## 3.0.2

- Gracefully fall back from `shareWithResult` to regular `share` methods on unsupported platforms

## 3.0.1

- Set min Flutter to 1.20.0 to match Share plugins on all platforms

## 3.0.0

- Add *WithResult methods to get feedback on user action

## 2.0.1

- Improve documentation

## 2.0.0

- Migrated to null safety

## 1.2.0

- Rename method channel to avoid conflicts

## 1.1.0

- Transfer to plus-plugins monorepo

## 1.0.0

- Initial release
