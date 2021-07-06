// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// Object encapsulating MACOS device information.
class MacOsDeviceInfo {
  /// Constructs a MacOsDeviceInfo.
  const MacOsDeviceInfo({
    required this.computerName,
    required this.hostName,
    required this.arch,
    required this.model,
    required this.kernelVersion,
    required this.osRelease,
    required this.activeCPUs,
    required this.memorySize,
    required this.cpuFrequency,
  });

  /// Name given to the local machine.
  final String computerName;

  /// Operating system type
  final String hostName;

  /// Machine cpu architecture
  final String arch;

  /// Device model
  final String model;

  /// Machine Kernel version.
  /// Examples:
  /// `Darwin Kernel Version 15.3.0: Thu Dec 10 18:40:58 PST 2015; root:xnu-3248.30.4~1/RELEASE_X86_64`
  /// or
  /// `Darwin Kernel Version 15.0.0: Wed Dec 9 22:19:38 PST 2015; root:xnu-3248.31.3~2/RELEASE_ARM64_S8000`
  final String kernelVersion;

  /// Operating system release number
  final String osRelease;

  /// Number of active CPUs
  final int activeCPUs;

  /// Machine's memory size
  final int memorySize;

  /// Device CPU Frequency
  final int cpuFrequency;

  /// Serializes [ MacOsDeviceInfo ] to map.
  Map<String, dynamic> toMap() {
    return {
      'arch': arch,
      'model': model,
      'hostName': hostName,
      'osRelease': osRelease,
      'activeCPUs': activeCPUs,
      'memorySize': memorySize,
      'cpuFrequency': cpuFrequency,
      'computerName': computerName,
      'kernelVersion': kernelVersion,
    };
  }

  /// Constructs a [MacOsDeviceInfo] from a Map of dynamic.
  static MacOsDeviceInfo fromMap(Map<dynamic, dynamic> map) {
    return MacOsDeviceInfo(
      computerName: map['computerName'],
      hostName: map['hostName'],
      arch: map['arch'],
      model: map['model'],
      kernelVersion: map['kernelVersion'],
      osRelease: map['osRelease'],
      activeCPUs: map['activeCPUs'],
      memorySize: map['memorySize'],
      cpuFrequency: map['cpuFrequency'],
    );
  }
}
