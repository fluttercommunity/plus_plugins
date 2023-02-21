# Android Intent Plugin for Flutter

[![Flutter Community: android_intent_plus](https://fluttercommunity.dev/_github/header/android_intent_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/android_intent_plus.svg)](https://pub.dev/packages/android_intent_plus)
[![pub points](https://img.shields.io/pub/points/android_intent_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/android_intent_plus/score)
[![android_intent_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_intent_plus.yaml)

<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>

This plugin allows Flutter apps to launch arbitrary intents when the platform is Android.

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

The Dart values supported for the `arguments` and the `arrayArguments` parameter, and their corresponding Java values, are listed [here](https://flutter.dev/platform-channels/#codec).

Lists in the `arguments` parameter are always translated to a Java `ArrayList`. Lists in the `arrayArguments` parameter are always translated to a Java `Array`.

For nesting values and mixing of `Array` and `ArrayList` values, you can use the `extras` parameter. The `extra` parameter accepts a `List<Bundle>` as parameter.

```dart
if (platform.isAndroid) {
  final AndroidIntent intent = AndroidIntent(
    action: 'com.example.broadcast',
    extras: <Bundle>[
      Bundle(
        value: [
          PutBundle(
            key: 'com.symbol.datawedge.api.SET_CONFIG',
            value: [
              PutString(
                key: 'PROFILE_NAME',
                value: 'com.dalosy.count_app',
              ),
              PutParcelableArray(
                key: 'APP_LIST',
                value: [
                  Bundle(
                    value: [
                      PutString(
                        key: 'PACKAGE_NAME',
                        value: 'com.dalosy.package',
                      ),
                      PutStringArray(
                        key: 'ACTIVITY_LIST',
                        value: ['*'],
                      ),
                      PutStringArrayList(
                        key: 'ACTIVITY_ARRAY_LIST',
                        value: ['1', '2'],
                      )
                    ],
                  )
                ],
              ),
              PutParcelableArrayList(
                key: 'PLUGIN_CONFIG',
                value: [
                  Bundle(
                    value: [
                      PutString(
                        key: 'PLUGIN_NAME',
                        value: 'BARCODE',
                      ),
                      PutBool(
                        key: 'RESET_CONFIG',
                        value: true,
                      ),
                      PutBundle(
                        key: 'PARAM_LIST',
                        value: [
                          PutString(
                            key: 'scanner_selection',
                            value: 'auto',
                          ),
                          PutInt(
                            key: 'picklist',
                            value: 1,
                          ),
                          PutIntArray(
                            key: 'int_array_test',
                            value: [1, 2, 3, 4, 5],
                          ),
                          PutIntArrayList(
                            key: 'int_array_list_test',
                            value: [1, 2, 3, 4, 5, 6],
                          ),
                          PutBoolArray(
                            key: 'bool_array_test',
                            value: [true, false, false, true],
                          ),
                        ],
                      )
                    ],
                  )
                ],
              )
            ],
          )
        ],
      ),
    ],
  );
  await intent.launch();
}
```

On the Android side, the `arguments`, `arrayArguments` and the `extras` parameters are used to populate an Android Bundle instance that is send with an Android Intent.

> **Note**
>
> There is no similar method for iOS. Instead, the
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

- [API Documentation](https://pub.dev/documentation/android_intent_plus/latest/)
- [Plugin documentation website](https://plus.fluttercommunity.dev/docs/android_intent_plus/overview)
