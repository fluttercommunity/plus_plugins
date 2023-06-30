/// A sensor sample from a attitude motion sensor.
///
/// Measures the attitude of the phone with respect to the Earth's magnatic field,
class AttitudeEvent {
  /// Constructs a new instance with the given [roll], [pitch], and [yaw] values.
  ///
  /// See [AttitudeEvent] for more information.
  AttitudeEvent(this.x, this.y, this.z);

  final double x, y, z;

  @override
  String toString() => '[AttitudeEvent (x: $x, y: $y, z: $z)]';
}
