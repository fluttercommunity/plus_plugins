[![Flutter Community: android_alarm_manager_plus](https://fluttercommunity.dev/_github/header/android_alarm_manager_plus)](https://github.com/fluttercommunity/community)

<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>
# android_alarm_manager_plus

A Flutter plugin for accessing the Android AlarmManager service, and running
Dart code in the background when alarms fire.

## Platform Support

| Android |
| :-----: |
|   ✔️    |

## Getting Started

After importing this plugin to your project as usual, add the following to your
`AndroidManifest.xml` within the `<manifest></manifest>` tags:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
```

Next, within the `<application></application>` tags, add:

```xml
<service
    android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmService"
    android:permission="android.permission.BIND_JOB_SERVICE"
    android:exported="false"/>
<receiver
    android:name="dev.fluttercommunity.plus.androidalarmmanager.AlarmBroadcastReceiver"
    android:exported="false"/>
<receiver
    android:name="dev.fluttercommunity.plus.androidalarmmanager.RebootBroadcastReceiver"
    android:enabled="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"></action>
    </intent-filter>
</receiver>

Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)
```

Then in Dart code add:

```dart
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

static void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

main() async {
  final int helloAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(...);
  await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);
}
```

`printHello` will then run (roughly) every minute, even if the main app ends. However, `printHello`
will not run in the same isolate as the main application. Unlike threads, isolates do not share
memory and communication between isolates must be done via message passing (see more documentation on
isolates [here](https://api.dart.dev/stable/2.0.0/dart-isolate/dart-isolate-library.html)).

## Using other plugins in alarm callbacks

If alarm callbacks will need access to other Flutter plugins, including the
alarm manager plugin itself, it may be necessary to inform the background service how
to initialize plugins depending on which Flutter Android embedding the application is
using.

### Flutter Android Embedding V2 (Flutter Version >= 1.12)

For the Flutter Android Embedding V2, plugins are registered with the background
isolate via reflection so `AlarmService.setPluginRegistrant` does not need to be
called.

**NOTE: this plugin is not completely compatible with the V2 embedding on
Flutter versions < 1.12 as the background isolate will not automatically
register plugins. This can be resolved by running `flutter upgrade` to upgrade
to the latest Flutter version.**

### Flutter Android Embedding V1 (DEPRECATED)

For the Flutter Android Embedding V1, the background service must be provided a
callback to register plugins with the background isolate. This is done by giving
the `AlarmService` a callback to call the application's `onCreate` method. See the example's
[Application overrides](https://github.com/fluttercommunity/plus_plugins/tree/main/packages/android_alarm_manager_plus/example/android/app/src/main/java/io/flutter/plugins/androidalarmmanagerexample/Application.java).

In particular, its `Application` class is as follows:

```java
public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    AlarmService.setPluginRegistrant(this);
  }

  @Override
  public void registerWith(PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
  }
}
```

Which must be reflected in the application's `AndroidManifest.xml`. E.g.:

```xml
    <application
        android:name=".Application"
        ...
```

**Note:** Not calling `AlarmService.setPluginRegistrant` will result in an exception being
thrown when an alarm eventually fires.

## Plugin Development

### Running Flutter unit tests

Run normally with `flutter test` from the root of the project.

### Running Espresso tests

The Espresso test runs the same sample code provided in `example/lib/main.dart`
but is run using the Flutter Espresso plugin.

Modifying the `main.dart` will cause this test to fail.

This test will call into the `example/lib/main_espresso.dart` file which
will enable Flutter Driver and then calls into the `main.dart`.

See https://pub.dev/packages/espresso for more info on why.

To run the test, run from the `example/android` folder:

```
./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../lib/main_espresso.dart
```

### Running End-to-end Flutter Driver tests

To run the Flutter Driver tests, cd into `example` and run:

```
flutter driver test_driver/android_alarm_manager_e2e.dart
```

**Important:** As of January 2021, the Flutter team is no longer accepting non-critical PRs for the original set of plugins in `flutter/plugins`, and instead they should be submitted in this project. [You can read more about this announcement here.](https://github.com/flutter/plugins/blob/master/CONTRIBUTING.md#important-note) as well as [in the Flutter 2 announcement blog post.](https://medium.com/flutter/whats-new-in-flutter-2-0-fe8e95ecc65)
