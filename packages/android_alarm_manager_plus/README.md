# android_alarm_manager_plus

[![Flutter Community: android_alarm_manager_plus](https://fluttercommunity.dev/_github/header/android_alarm_manager_plus)](https://github.com/fluttercommunity/community)

[![pub package](https://img.shields.io/pub/v/android_alarm_manager_plus.svg)](https://pub.dev/packages/android_alarm_manager_plus)
[![pub points](https://img.shields.io/pub/points/android_alarm_manager_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/android_alarm_manager_plus/score)
[![android_alarm_manager_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_alarm_manager_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_alarm_manager_plus.yaml)

<center><a href="https://flutter.dev/docs/development/packages-and-plugins/favorites" target="_blank" rel="noreferrer noopener"><img src="../../website/static/img/flutter-favorite-badge.png" width="100" alt="build"></a></center>

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

// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
@pragma('vm:entry-point')
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

## FAQ

### Does this plugin support to invoke a method after reboot?

From the Android AlarmManager documentation:

> Registered alarms are retained while the device is asleep (and can optionally wake the device up if they go off
during that time), but will be cleared if it is turned off and rebooted.

https://developer.android.com/reference/android/app/AlarmManager

### My alarm is not firing after force stopping the app

The Android OS will not fire alarms for apps that have been force stopped.

StackOverflow response: https://stackoverflow.com/questions/11241794/alarm-set-in-app-with-alarmmanager-got-removed-when-app-force-stop

### My alarm is not firing on a specific device

Likely the device is running some battery optimization software that is preventing the alarm from firing.
Check out https://dontkillmyapp.com/ to find out about more about optimizations done by different vendors.

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
flutter driver test_driver/android_alarm_manager_plus_e2e.dart
```
