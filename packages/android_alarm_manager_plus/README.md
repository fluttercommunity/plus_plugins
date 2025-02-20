# android_alarm_manager_plus

[![pub package](https://img.shields.io/pub/v/android_alarm_manager_plus.svg)](https://pub.dev/packages/android_alarm_manager_plus)
[![pub points](https://img.shields.io/pub/points/android_alarm_manager_plus?color=2E8B57&label=pub%20points)](https://pub.dev/packages/android_alarm_manager_plus/score)
[![android_alarm_manager_plus](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_alarm_manager_plus.yaml/badge.svg)](https://github.com/fluttercommunity/plus_plugins/actions/workflows/android_alarm_manager_plus.yaml)

[<img src="../../assets/flutter-favorite-badge.png" width="100" />](https://flutter.dev/docs/development/packages-and-plugins/favorites)

A Flutter plugin for accessing the Android AlarmManager service, and running
Dart code in the background when alarms fire.

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

## Getting Started

> [!IMPORTANT]
> You would also need a plugin to request [SCHEDULE_EXACT_ALARM](https://developer.android.com/reference/android/Manifest.permission#SCHEDULE_EXACT_ALARM) permission if your app targets Android 14 and newer.
> Google introduced SCHEDULE_EXACT_ALARM permission in [Android 12](https://developer.android.com/about/versions/12/behavior-changes-12#exact-alarm-permission). In Android 13 it was granted by default.
> Since Android 14 this permission [is denied by default](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms) and apps need to ask user to provide it.
> `android_alarm_manager_plus` does not provide a way to work with this permission, so be sure to handle such logic yourself.
> To do so you would need an additional plugin, like [`permission_handler`](https://pub.dev/packages/permission_handler).

After importing this plugin to your project as usual, add the following to your
`AndroidManifest.xml` within the `<manifest></manifest>` tags:

```xml
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.WAKE_LOCK"/>
<!-- For apps with targetSDK 31 (Android 12) and newer -->
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

## Receiving show intents for alarm clocks

If your app is an alarm clock app and sets alarms using the `alarmClock` argument in [`oneShot`](https://pub.dev/documentation/android_alarm_manager_plus/latest/android_alarm_manager_plus/AndroidAlarmManager/oneShot.html) or [`oneShotAt`](https://pub.dev/documentation/android_alarm_manager_plus/latest/android_alarm_manager_plus/AndroidAlarmManager/oneShotAt.html), you can receive [intents](https://developer.android.com/reference/android/content/Intent) when user interacts with system UI that shows the next alarm. An example is the alarm tile in Android [quick-setting tiles](https://developer.android.com/develop/ui/views/quicksettings-tiles). This functionality is to allow you to show users the relevant alarm, or allow them to edit it when they tap on such UIs.

This intent has the action `android.intent.action.MAIN` and includes the following `extras`:
- `id`: The alarm id that you passed when scheduling the alarm.
- `params`: The params argument that you passed when scheduling the alarm, if any.

### Example

Setting the alarm:

```dart
await AndroidAlarmManager.oneShotAt(
    time,
    id,
    callback,
    alarmClock: true,
    params: {
        'param1': 'Hello',
        'param2': 'World'
    }
    ...
)
```

To receive this intent in dart, you can use the [receive_intent](https://pub.dev/packages/receive_intent) package:

```dart
import 'package:receive_intent/receive_intent.dart';
import 'dart:convert'; // for jsonDecode

final receivedIntent = await ReceiveIntent.getInitialIntent();
if (receivedIntent.action == "android.intent.action.MAIN"){
    final paramsExtra = receivedIntent.extra?["params"];
    if (paramsExtra != null){
      // The received params is a string, so we need to convert it into a json map
      final params = jsonDecode(params);
      // use params
      // params['param1']
      // params['param2']
    }
    final id = receivedIntent.extra?["id"];
    // navigate user to alarm with given id
}
```
For more information, check out the receive_intent [getting started](https://pub.dev/packages/receive_intent#getting-started).

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

## Learn more

- [API Documentation](https://pub.dev/documentation/android_alarm_manager_plus/latest/android_alarm_manager_plus/android_alarm_manager_plus-library.html)
