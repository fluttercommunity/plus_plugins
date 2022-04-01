# Share plugin

[![Flutter Community: share_plus](https://fluttercommunity.dev/_github/header/share_plus)](https://github.com/fluttercommunity/community)

[![share_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/share_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/share_plus.yaml)
[![pub package](https://img.shields.io/pub/v/share_plus.svg)](https://pub.dev/packages/share_plus)

<a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a>

A Flutter plugin to share content from your Flutter app via the platform's
share dialog.

Wraps the `ACTION_SEND` Intent on Android and `UIActivityViewController`
on iOS.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Windows |
| :-----: | :-: | :---: | :-: | :---: | :----: |
|   ✔️    | ✔️  |  ✔️   | ✔️  |  ✔️   |   ✔️   |

Also compatible with Windows and Linux by using "mailto" to share text via Email.

Sharing files is not supported on Windows and Linux.

## Usage

To use this plugin, add `share_plus` as a [dependency in your pubspec.yaml file](https://plus.fluttercommunity.dev/docs/overview).

## Example

Import the library.

```dart
import 'package:share_plus/share_plus.dart';
```

Then invoke the static `share` method anywhere in your Dart code.

```dart
Share.share('check out my website https://example.com');
```

The `share` method also takes an optional `subject` that will be used when
sharing to email.

```dart
Share.share('check out my website https://example.com', subject: 'Look what I made!');
```

To share one or multiple files invoke the static `shareFiles` method anywhere in your Dart code. Optionally you can also pass in `text` and `subject`.

```dart
Share.shareFiles(['${directory.path}/image.jpg'], text: 'Great picture');
Share.shareFiles(['${directory.path}/image1.jpg', '${directory.path}/image2.jpg']);
```

To share file with specific app invoke the static `shareFileWithApp` method anywhere in your Dart code. You have to pass `appName` defined in `ShareWithAppWindows`.
Currently supports **Windows** platform only. By default, `ShareWithAppWindows.BY_DEFAULT_APP` will open default app handled by system.

```dart
Share.shareFileWithApp('${directory.path}/image.jpg',ShareWithAppWindows.BY_DEFAULT_APP );
Share.shareFileWithApp('${directory.path}/info.txt',ShareWithAppWindows.NOTEPAD );
```

Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)

## Known Issues

### Mobile platforms (Android and iOS)

Due to restrictions set up by Facebook this plugin isn't capable of sharing data reliably to Facebook related apps on Android and iOS. This includes eg. sharing text to the Facebook Messenger. If you require this functionality please check the native Facebook Sharing SDK ([https://developers.facebook.com/docs/sharing](https://developers.facebook.com/docs/sharing)) or search for other Flutter plugins implementing this SDK. More information can be found in [this issue](https://github.com/fluttercommunity/plus_plugins/issues/413).


[Feature] share_plus , Share file with desktop app or handle by system. Windows only

## Description

Added `shareFileWithApp()` , which can open file with its data as input to specific list of apps . It skips browser requirement to launch an app on desktop. The supported apps in plugin is `MSPAINT, NOTEPAD, PHOTOSHOP, EDGE, CHROME, NOTEPAD_PLUS_PLUS` or `BY_DEFAULT_APP` will  make file handle by system defaults app.

## Related Issues

Before sharing file was not available for desktop apps in plugin, and Browser was required to launch some basic app.

## Checklist

Before you create this PR confirm that it meets all requirements listed below by checking the relevant checkboxes (`[x]`).
This will ensure a smooth and quick review process.

- [ ] I read the [Contributor Guide] and followed the process outlined there for submitting PRs.
- [ ] My PR includes unit or integration tests for *all* changed/updated/fixed behaviors (See [Contributor Guide]).
- [ ] All existing and new tests are passing.
- [ ] I updated the version in `pubspec.yaml` and `CHANGELOG.md`.
- [ ] I updated/added relevant documentation (doc comments with `///`).
- [ ] The analyzer (`flutter analyze`) does not report any problems on my PR.
- [ ] I read and followed the [Flutter Style Guide].
- [ ] I am willing to follow-up on review comments in a timely manner.

## Breaking Change

Does your PR require plugin users to manually update their apps to accommodate your change?

- [ ] Yes, this is a breaking change (please indicate a breaking change in CHANGELOG.md and increment major revision).
- [ ] No, this is *not* a breaking change.

<!-- Links -->
[issue database]: https://github.com/flutter/flutter/issues
[Contributor Guide]: https://github.com/fluttercommunity/plus_plugins/blob/main/CONTRIBUTING.md
[Flutter Style Guide]: https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo
[pub versioning philosophy]: https://dart.dev/tools/pub/versioning

