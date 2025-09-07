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

| Shared content | Android | iOS | macOS | Web | Linux | Windows |
| :------------: | :-----: | :-: | :---: | :-: | :---: | :-----: |
| Text           |   ✅    | ✅  |  ✅   | ✅  |  ✅   |   ✅   |
| URI            |   ✅    | ✅  |  ✅   | As text | As text | As text |
| Files          |   ✅    | ✅  |  ✅   | ✅  |  ❌   |   ✅   |

Also compatible with Windows and Linux by using "mailto" to share text via Email.

Sharing files is not supported on Linux.

## Requirements

- Flutter >=3.22.0
- Dart >=3.4.0 <4.0.0
- iOS >=12.0
- macOS >=10.14
- Java 17
- Kotlin 2.2.0
- Android Gradle Plugin >=8.12.1
- Gradle wrapper >=8.13

## Usage

To use this plugin, add `share_plus` as a [dependency in your pubspec.yaml file](https://plus.fluttercommunity.dev/docs/overview).

Import the library.

```dart
import 'package:share_plus/share_plus.dart';
```

### Share Text

Access the `SharePlus` instance via `SharePlus.instance`.
Then, invoke the `share()` method anywhere in your Dart code.

```dart
import 'package:share_plus/share_plus.dart';

SharePlus.instance.share(
  ShareParams(text: 'check out my website https://example.com')
);
```

The `share()` method requires the `ShareParams` object,
which contains the content to share.

These are some of the accepted parameters of the `ShareParams` class:

- `text`: text to share.
- `title`: content or share-sheet title (if supported).
- `subject`: email subject (if supported).

Check the class documentation for more details.

`share()` returns `status` object that allows to check the result of user action in the share sheet.

```dart
final result = await SharePlus.instance.share(params);

if (result.status == ShareResultStatus.success) {
    print('Thank you for sharing my website!');
}
```

### Share Files

To share one or multiple files, provide the `files` list in `ShareParams`.
Optionally, you can pass `title`, `text` and `sharePositionOrigin`.

```dart
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

final params = ShareParams(
  text: 'Great picture',
  files: [XFile('${directory.path}/image.jpg')],
);

final result = await SharePlus.instance.share(params);

if (result.status == ShareResultStatus.success) {
    print('Thank you for sharing the picture!');
}
```

```dart
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

final params = ShareParams(
  files: [
    XFile('${directory.path}/image1.jpg'),
    XFile('${directory.path}/image2.jpg'),
  ],
);

final result = await SharePlus.instance.share(params);

if (result.status == ShareResultStatus.dismissed) {
    print('Did you not like the pictures?');
}
```

On web, this uses the [Web Share API](https://web.dev/web-share/)
if it's available. Otherwise it falls back to downloading the shared files.
See [Can I Use - Web Share API](https://caniuse.com/web-share) to understand
which browsers are supported. This builds on the [`cross_file`](https://pub.dev/packages/cross_file)
package.

File downloading fallback mechanism for web can be disabled by setting:

```dart
import 'package:share_plus/share_plus.dart';

ShareParams(
  // rest of params
  downloadFallbackEnabled: false,
)
```

#### Share Data

You can also share files that you dynamically generate from its data using [`XFile.fromData`](https://pub.dev/documentation/share_plus/latest/share_plus/XFile/XFile.fromData.html).

To set the name of such files, use the `fileNameOverrides` parameter, otherwise the file name will be a random UUID string.

```dart
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';
import 'dart:convert';

final params = ShareParams(
  files: [XFile.fromData(utf8.encode(text), mimeType: 'text/plain')],
  fileNameOverrides: ['myfile.txt']
);

SharePlus.instance.share(params);
```

> [!CAUTION]
> The `name` parameter in the `XFile.fromData` method is ignored in most platforms. Use `fileNameOverrides` instead.

### Share URI

iOS supports fetching metadata from a URI when shared using `UIActivityViewController`.
This special functionality is only properly supported on iOS.
On other platforms, the URI will be shared as plain text.

```dart
import 'package:share_plus/share_plus.dart';

final params = ShareParams(uri: uri);

SharePlus.instance.share(params);
```

### Share Results

All three methods return a `ShareResult` object which contains the following information:

- `status`: a `ShareResultStatus`
- `raw`: a `String` describing the share result, e.g. the opening app ID.

Note: `status` will be `ShareResultStatus.unavailable` if the platform does not support identifying the user action.

### Other Parameters

#### Title

Used as share sheet title where supported.

- Provided to Android's `Intent.createChooser` as the title, as well as, `EXTRA_TITLE` Intent extra.
- Provided to web Navigator Share API as title.

```dart
ShareParams(
  // rest of params
  title: 'Title',
)
```

#### Subject

Used as email subject where supported (e.g. `EXTRA_SUBJECT` on Android)

When using the email fallback, this will be the subject of the email.

```dart
ShareParams(
  // rest of params
  subject: 'Subject',
)
```

#### Excluded Cupertino Activities

On iOS or macOS, if you want to exclude certain options from appearing in your share sheet, you can set the `excludedCupertinoActivities` array.

For the list of supported `excludedCupertinoActivities`, refer to [CupertinoActivityType](https://pub.dev/documentation/share_plus/latest/share_plus/ShareParams-class.html).

```dart
ShareParams(
  // rest of params
  excludedCupertinoActivities: [CupertinoActivityType.postToFacebook],
)
```

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

We cannot guarantee that a 3rd party app will properly implement the share functionality.
Therefore, **all bugs reported regarding compatibility with a specific app will be closed.**

#### Localization in Apple platforms

It could happen that the Share sheet appears with a different language, [as reported here](https://github.com/fluttercommunity/plus_plugins/issues/2696).

To fix this issue, you will have to setup the keys `CFBundleAllowMixedLocalizations` and `CFBundleDevelopmentRegion` in your project's `info.plist`.

For more information check the [CoreFoundationKeys](https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html) documentation.

#### iPad

`share_plus` requires iPad users to provide the `sharePositionOrigin` parameter.

Without it, `share_plus` will not work on iPads and may cause a crash or
leave the UI unresponsive.

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

await SharePlus.instance.share(
  ShareParams(
    text: text,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  )
);
```

See the `main.dart` in the `example` for a complete example.

## Migrating from `Share.share()` to `SharePlus.instance.share()`

The static methods `Share.share()`, `Share.shareUri()` and `Share.shareXFiles()`
have been deprecated in favor of the `SharePlus.instance.share(params)`.

To convert code using `Share.share()` to the new `SharePlus` class:

1. Wrap the current parameters in a `ShareParams` object.
2. Change the call to `SharePlus.instance.share()`.

e.g.

```dart
import 'package:share/share.dart';

Share.share("Shared text");

Share.shareUri("http://example.com");

Share.shareXFiles(files);
```

Becomes:

```dart
import 'package:share_plus/share_plus.dart';

SharePlus.instance.share(
  ShareParams(text: "Shared text"),
);

SharePlus.instance.share(
  ShareParams(uri: "http://example.com"),
);

SharePlus.instance.share(
  ShareParams(files: files),
);
```

## Learn more

- [API Documentation](https://pub.dev/documentation/share_plus/latest/share_plus/share_plus-library.html)
