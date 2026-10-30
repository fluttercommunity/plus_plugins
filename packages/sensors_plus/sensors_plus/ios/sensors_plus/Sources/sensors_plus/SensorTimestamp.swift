// Copyright 2026 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Foundation

func sensorTimestampToUnixMicroseconds(
  _ sensorTimestamp: TimeInterval,
  currentUptime: TimeInterval = ProcessInfo.processInfo.systemUptime,
  currentUnixTime: TimeInterval = Date().timeIntervalSince1970
) -> Double {
  // Uptime excludes sleep, so its offset from wall time must not be cached
  // across callbacks. Preserve the measurement's age instead of timestamping
  // it at delivery time.
  let sampleAge = currentUptime - sensorTimestamp
  return (currentUnixTime - sampleAge) * 1_000_000
}
