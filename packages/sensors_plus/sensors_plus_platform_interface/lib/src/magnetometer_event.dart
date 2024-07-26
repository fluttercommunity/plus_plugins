/// A sensor sample from a magnetometer.
///
/// Magnetometers measure the ambient magnetic field surrounding the sensor,
/// returning values in microteslas ***μT*** for each three-dimensional axis.
///
/// Consider that these samples may bear effects of Earth's magnetic field as
/// well as local factors such as the metal of the device itself or nearby
/// magnets, though most devices compensate for these factors.
///
/// A compass is an example of a general utility for magnetometer data.
class MagnetometerEvent {
  /// Constructs a new instance with the given [x], [y], and [z] values.
  ///
  /// See [MagnetometerEvent] for more information.
  MagnetometerEvent(this.x, this.y, this.z, this.timestamp);

  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
  final double x, y, z;

  /// timestamp of the event
  ///
  /// This is the timestamp of the event in microseconds, as provided by the
  /// underlying platform. For Android, this is the uptimeMillis provided by
  /// the SensorEvent. For iOS, this is the timestamp provided by the CMDeviceMotion.

  final DateTime timestamp;

  @override
  String toString() => '[MagnetometerEvent (x: $x, y: $y, z: $z, timestamp: $timestamp)]';
}
