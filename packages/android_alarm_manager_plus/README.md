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
<!-- For apps with targetSDK=31 (Android 12) -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
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
    android:enabled="false"
    android:exported="false">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
    </intent-filter>
</receiver>

```
Check out our documentation website to learn more. [Plus plugins documentation](https://plus.fluttercommunity.dev/docs/overview)

Then in Dart code add:

```dart
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

static void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
}

main() async {
  // Be sure to add this line if initialize() call happens before runApp()
  WidgetsFlutterBinding.ensureInitialized();

  await AndroidAlarmManager.initialize();
  runApp(...);
  final int helloAlarmID = 0;
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
