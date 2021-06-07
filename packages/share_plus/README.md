[![Flutter Community: share_plus](https://fluttercommunity.dev/_github/header/share_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/share_plus.svg)](https://pub.dev/packages/share_plus)

<p class="center">
<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>
</p>
# Share plugin

A Flutter plugin to share content from your Flutter app via the platform's
share dialog.

Wraps the ACTION_SEND Intent on Android and UIActivityViewController
on iOS.

## Platform Support

| Android | iOS | MacOS | Web | Linux | Window |
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

Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)

**Important:** As of January 2021, the Flutter team is no longer accepting non-critical PRs for the original set of plugins in `flutter/plugins`, and instead they should be submitted in this project. [You can read more about this announcement here.](https://github.com/flutter/plugins/blob/master/CONTRIBUTING.md#important-note) as well as [in the Flutter 2 announcement blog post.](https://medium.com/flutter/whats-new-in-flutter-2-0-fe8e95ecc65)
