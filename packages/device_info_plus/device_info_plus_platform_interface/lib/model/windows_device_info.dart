// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'base_device_info.dart';

/// Object encapsulating WINDOWS device information.
class WindowsDeviceInfo implements BaseDeviceInfo {
  /// Constructs a [WindowsDeviceInfo].
  WindowsDeviceInfo({
    required this.computerName,
    required this.numberOfCores,
    required this.systemMemoryInMegabytes,
  });

  /// The computer's fully-qualified DNS name, where available.
  final String computerName;

  /// Number of CPU cores on the local machine
  final int numberOfCores;

  /// The physically installed memory in the computer.
  /// This may not be the same as available memory.
  final int systemMemoryInMegabytes;
}
