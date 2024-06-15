# share_plus

[![share_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/share_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/share_plus.yaml)
[![pub points](https://img.shields.io/pub/points/share_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/share_plus/score)
[![pub package](https://img.shields.io/pub/v/share_plus.svg)](https://pub.dev/packages/share_plus)

[<img src="../../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

A Flutter plugin to share content from your Flutter app via the platform's
share dialog.

Wraps the `ACTION_SEND` Intent on Android, `UIActivityViewController`
on iOS, or equivalent platform content sharing methods.

## Platform Support

| Method        | Android | iOS | MacOS | Web | Linux | Windows |
| :-----------: | :-----: | :-: | :---: | :-: | :---: | :----: |
| `share`       |   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅   |
| `shareUri`    |   ✅    | ✅  |       |     |       |        |
| `shareXFiles` |   ✅    | ✅  |  ✅   | ✅  |       |   ✅   |

Also compatible with Windows and Linux by using "mailto" to share text via Email.

Sharing files is not supported on Linux.

## Requirements

- Flutter >=3.3.0
- Dart >=2.18.0 <4.0.0
- iOS >=12.0
- MacOS >=10.14
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

## Usage

To use this plugin, add `share_plus` as a [dependency in your pubspec.yaml file](https://plus.fluttercommunity.dev/docs/overview).

Import the library.

```dart
import 'package:share_plus/share_plus.dart';
```

### Share Text

Invoke the static `share()` method anywhere in your Dart code.

```dart
Share.share('check out my website https://example.com');
```

The `share` method also takes an optional `subject` that will be used when
sharing to email.

```dart
Share.share('check out my website https://example.com', subject: 'Look what I made!');
```

`share()` returns `status` object that allows to check the result of user action in the share sheet.

```dart
final result = await Share.share('check out my website https://example.com');

if (result.status == ShareResultStatus.success) {
    print('Thank you for sharing my website!');
}
```

### Share Files

To share one or multiple files, invoke the static `shareXFiles` method anywhere in your Dart code. The method returns a `ShareResult`. Optionally, you can pass `subject`, `text` and `sharePositionOrigin`.

```dart
final result = await Share.shareXFiles([XFile('${directory.path}/image.jpg')], text: 'Great picture');

if (result.status == ShareResultStatus.success) {
    print('Thank you for sharing the picture!');
}
```

```dart
final result = await Share.shareXFiles([XFile('${directory.path}/image1.jpg'), XFile('${directory.path}/image2.jpg')]);

if (result.status == ShareResultStatus.dismissed) {
    print('Did you not like the pictures?');
}
```

On web, you can use `SharePlus.shareXFiles()`. This uses the [Web Share API](https://web.dev/web-share/)
if it's available. Otherwise it falls back to downloading the shared files.
See [Can I Use - Web Share API](https://caniuse.com/web-share) to understand
which browsers are supported. This builds on the [`cross_file`](https://pub.dev/packages/cross_file)
package.


```dart
Share.shareXFiles([XFile('assets/hello.txt')], text: 'Great picture');
```

### Share URI

iOS supports fetching metadata from a URI when shared using `UIActivityViewController`.
This special method is only properly supported on iOS.

```dart
Share.shareUri(uri: uri);
```

### Share Results

All three methods return a `ShareResult` object which contains the following information:

- `status`: a `ShareResultStatus`
- `raw`: a `String` describing the share result, e.g. the opening app ID.

Note: `status` will be `ShareResultStatus.unavailable` if the platform does not support identifying the user action.

## Known Issues

### Sharing data created with XFile.fromData

When sharing data created with `XFile.fromData`, the plugin will write a temporal file inside the cache directory of the app, so it can be shared.

Although the OS should take care of deleting those files, it is advised, that you clean up this data once in a while (e.g. on app start).

You can access this directory using [path_provider](https://pub.dev/packages/path_provider) [getTemporaryDirectory](https://pub.dev/documentation/path_provider/latest/path_provider/getTemporaryDirectory.html).

Alternatively, don't use `XFile.fromData` and instead write the data down to a `File` with a path before sharing it, so you control when to delete it.

### Mobile platforms (Android and iOS)

#### Sharing images + text

When attempting to share images with text, some apps may fail to properly accept the share action with them.

For example, due to restrictions set up by Meta/Facebook this plugin isn't capable of sharing data reliably
to Facebook related apps on Android and iOS. This includes eg. sharing text to the Facebook Messenger.

If you require this functionality please check the native Facebook Sharing SDK ([https://developers.facebook.com/docs/sharing](https://developers.facebook.com/docs/sharing))
or search for other Flutter plugins implementing this SDK. More information can be found in [this issue](https://github.com/fluttercommunity/plus_plugins/issues/413).

Other apps may also give problems when attempting to share content to them.
This is because 3rd party app developers do not properly implement the logic to receive share actions.

We cannot warranty that a 3rd party app will properly implement the share functionality.
Therefore, **all bugs reported regarding compatibility with a specific app will be closed.**

#### Localization in Apple platforms

It could happen that the Share sheet appears with a different language, [as reported here](https://github.com/fluttercommunity/plus_plugins/issues/2696).

To fix this issue, you will have to setup the keys `CFBundleAllowMixedLocalizations` and `CFBundleDevelopmentRegion` in your project's `info.plist`.

For more information check the [CoreFoundationKeys](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html) documentation.

#### iPad

`share_plus` requires iPad users to provide the `sharePositionOrigin` parameter.

Without it, `share_plus` will not work on iPads and may cause a crash or
letting the UI not responding.

To avoid that problem, provide the `sharePositionOrigin`.

For example:

```dart
// Use Builder to get the widget context
Builder(
  builder: (BuildContext context) {
    return ElevatedButton(
      onPressed: () => _onShare(context),
          child: const Text('Share'),
     );
  },
),

// _onShare method:
final box = context.findRenderObject() as RenderBox?;

await Share.share(
  text,
  subject: subject,
  sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
);
```

See the `main.dart` in the `example` for a complete example.

## Learn more

- [API Documentation](https://pub.dev/documentation/share_plus/latest/share_plus/share_plus-library.html)
