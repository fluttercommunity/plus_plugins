import 'package:meta/meta.dart';

@sealed
class SensorInterval {
  static const normalInterval = Duration(milliseconds: 200);
  static const uiInterval = Duration(milliseconds: 66, microseconds: 667);
  static const gameInterval = Duration(milliseconds: 20);
  static const fastestInterval = Duration.zero;
}
