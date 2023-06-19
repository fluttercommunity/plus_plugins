/// A sensor sample from a game rotation vector.
///
/// Identical to Sensor.TYPE_ROTATION_VECTOR except that it doesn't use the
/// geomagnetic field. Therefore the Y axis doesn't point north, but instead
/// to some other reference, that reference is allowed to drift by the same
/// order of magnitude as the gyroscope drift around the Z axis.
///
/// In the ideal case, a phone rotated and returning to the same real-world
/// orientation will report the same game rotation vector (without using the
/// earth's geomagnetic field). However, the orientation may drift somewhat
/// over time. See Sensor.TYPE_ROTATION_VECTOR for a detailed description
/// of the values. This sensor will not have the estimated heading accuracy
/// value.
///
/// A compass is an example of a general utility for gameRotationVector data.
class GameRotationVectorEvent {
  /// Constructs a new instance with the given [x], [y], [z] and [w] values.
  ///
  /// See [GameRotationVectorEvent] for more information.
  GameRotationVectorEvent(this.x, this.y, this.z, this.w);

  /// The ambient magnetic field in this axis surrounding the sensor in
  /// microteslas ***μT***.
  final double x, y, z, w;

  @override
  String toString() => '[GameRotationVectorEvent (x: $x, y: $y, z: $z, w: $w)]';
}
