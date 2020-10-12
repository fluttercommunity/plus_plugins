import 'package:flutter_driver/driver_extension.dart';
import 'package:android_alarm_manager_example/main.dart' as app;

/// Used only in the Android Espresso tests
///
/// To run the tests, from the android folder:
/// ./gradlew app:connectedAndroidTest -Ptarget=`pwd`/../lib/main_espresso.dart
void main() {
  enableFlutterDriverExtension();
  app.main();
}
