# android_intent_plus

[![pub package](https://img.shields.io/pub/v/android_intent_plus.svg)](https://pub.dev/packages/android_intent_plus)
[![pub points](https://img.shields.io/pub/points/android_intent_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/android_intent_plus/score)
[![android_intent_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml)

[<img src="../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

This plugin allows Flutter apps to launch arbitrary intents when the platform is Android.

## Platform Support

| Android |
| :-----: |
|   ✅    |

## Requirements

- Flutter >=3.12.0
- Dart >=3.1.0 <4.0.0
- Android `compileSDK` 34
- Java 17
- Android Gradle Plugin >=8.3.0
- Gradle wrapper >=8.4

## Usage

> **Warning**
>
> If the plugin is invoked on iOS, it will crash your app. In checked mode, we assert that the platform should be Android.

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

> **Note**
>
> There is no similar method for iOS. Instead, the
> [url_launcher](https://pub.dartlang.org/packages/url_launcher) plugin
> can be used for deep linking. Url launcher can also be used for creating
> ACTION_VIEW intents for Android, however this intent plugin also allows
> clients to set extra parameters for the intent.

### Querying activities
`canResolveActivity()` and `getResolvedActivity()` can be used to query whether an activity can handle an intent,
or get the details of the activity that can handle the intent.

```dart
final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('http://'),
    );

// can this intent be handled by an activity
final canHandleIntent = await intent.canResolveActivity();

// get the details of the activity that will handle this intent
final details = await intent.getResolvedActivity();

print(details.packageName); // prints com.google.chrome
```

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

- [API Documentation](https://pub.dev/documentation/android_intent_plus/latest/)
