// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Discrete reading from a gyroscope. Gyroscopes measure the rate or rotation of
/// the device in 3D space.
class GyroscopeEvent {
  /// Constructs an instance with the given [x], [y], and [z] values.
  GyroscopeEvent(this.x, this.y, this.z, this.timestamp);

  /// Rate of rotation around the x axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "pitch". The top of the device will tilt towards or away from the
  /// user as this value changes.
  final double x;

  /// Rate of rotation around the y axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "yaw". The lengthwise edge of the device will rotate towards or away from
  /// the user as this value changes.
  final double y;

  /// Rate of rotation around the z axis measured in rad/s.
  ///
  /// When the device is held upright, this can also be thought of as describing
  /// "roll". When this changes the face of the device should remain facing
  /// forward, but the orientation will change from portrait to landscape and so
  /// on.
  final double z;

  /// timestamp of the event
  ///
  /// This is the timestamp of the event in microseconds, as provided by the
  /// underlying platform. For Android, this is the uptimeMillis provided by
  /// the SensorEvent. For iOS, this is the timestamp provided by the CMDeviceMotion.

  final DateTime timestamp;

  @override
  String toString() =>
      '[GyroscopeEvent (x: $x, y: $y, z: $z, timestamp: $timestamp)]';
}
