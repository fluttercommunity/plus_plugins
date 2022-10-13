# Android Intent Plugin for Flutter

[![Flutter Community: android_intent_plus](https://fluttercommunity.dev/_github/header/android_intent_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/android_intent_plus.svg)](https://pub.dev/packages/android_intent_plus)
[![pub points](https://img.shields.io/pub/points/android_intent_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/android_intent_plus/score)
[![android_intent_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml)

<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>

This plugin allows Flutter apps to launch arbitrary intents when the platform
is Android. If the plugin is invoked on iOS, it will crash your app. In checked
mode, we assert that the platform should be Android.

Use it by specifying action, category, data and extra arguments for the intent.
It does not support returning the result of the launched activity. Sample usage:

```dart
if (platform.isAndroid) {
  AndroidIntent intent = AndroidIntent(
      action: 'action_view',
      data: 'https://play.google.com/store/apps/details?'
          'id=com.google.android.apps.myapp',
      arguments: {'authAccount': currentUserEmail},
  );
  await intent.launch();
}
```

See documentation on the AndroidIntent class for details on each parameter.

Action parameter can be any action including a custom class name to be invoked.
If a standard android action is required, the recommendation is to add support
for it in the plugin and use an action constant to refer to it. For instance:

`'action_view'` translates to `android.os.Intent.ACTION_VIEW`

`'action_location_source_settings'` translates to `android.settings.LOCATION_SOURCE_SETTINGS`

`'action_application_details_settings'` translates to `android.settings.ACTION_APPLICATION_DETAILS_SETTINGS`

```dart
if (platform.isAndroid) {
  final AndroidIntent intent = AndroidIntent(
    action: 'action_application_details_settings',
    data: 'package:com.example.app', // replace com.example.app with your applicationId
  );
  await intent.launch();
}

```

Feel free to add support for additional Android intents.

The Dart values supported for the arguments parameter, and their corresponding
Android values, are listed [here](https://flutter.dev/platform-channels/#codec).
On the Android side, the arguments are used to populate an Android `Bundle`
instance. This process currently restricts the use of lists to homogeneous lists
of integers or strings.

> Note that a similar method does not currently exist for iOS. Instead, the
> [url_launcher](https://pub.dartlang.org/packages/url_launcher) plugin
> can be used for deep linking. Url launcher can also be used for creating
> ACTION_VIEW intents for Android, however this intent plugin also allows
> clients to set extra parameters for the intent.

## Platform Support

| Android |
| :-----: |
|   ✔️    |

## Android 11 package visibility

Android 11 introduced new permissions for package visibility.
If you plan to use `canResolveActivity()` method, you need to specify queries in `AndroidManifest.xml` with specific package names:

https://developer.android.com/training/package-visibility/declaring

you can read more about package visibility on Android on Android Developers blog:

https://medium.com/androiddevelopers/package-visibility-in-android-11-cc857f221cd9

or Official Documentation

https://developer.android.com/training/package-visibility

please note that some packages are visible automatically and you don't have to specify queries:

https://developer.android.com/training/package-visibility/automatic

## Learn more

Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)
