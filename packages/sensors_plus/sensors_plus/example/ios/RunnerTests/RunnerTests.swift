import XCTest

@testable import sensors_plus

class RunnerTests: XCTestCase {

  private let unixTime: TimeInterval = 1_700_000_000
  private let accuracyMicroseconds: Double = 1

  func testConvertsUptimeToUnixMicroseconds() {
    let actual = sensorTimestampToUnixMicroseconds(
      1000, currentUptime: 1000, currentUnixTime: unixTime)

    XCTAssertEqual(actual, unixTime * 1_000_000, accuracy: accuracyMicroseconds)
  }

  func testRefreshesConversionAfterSimulatedSleep() {
    let before = sensorTimestampToUnixMicroseconds(
      1000, currentUptime: 1000, currentUnixTime: unixTime)
    // Two minutes pass in wall time while uptime is paused. A new sample is
    // then measured ten uptime seconds later in the same app process.
    let after = sensorTimestampToUnixMicroseconds(
      1010, currentUptime: 1010, currentUnixTime: unixTime + 130)

    XCTAssertEqual(after - before, 130_000_000, accuracy: accuracyMicroseconds)
  }

  func testPreservesMeasurementTimeForDelayedDelivery() {
    let actual = sensorTimestampToUnixMicroseconds(
      999.75, currentUptime: 1000, currentUnixTime: unixTime)

    XCTAssertEqual(actual, (unixTime - 0.25) * 1_000_000, accuracy: accuracyMicroseconds)
  }

  func testPreservesSampleSpacingDespiteDifferentDeliveryDelays() {
    let first = sensorTimestampToUnixMicroseconds(
      1000, currentUptime: 1001, currentUnixTime: unixTime + 1)
    let second = sensorTimestampToUnixMicroseconds(
      1000.02, currentUptime: 1004, currentUnixTime: unixTime + 4)

    XCTAssertEqual(second - first, 20_000, accuracy: accuracyMicroseconds)
  }

  func testUsesCurrentWallTimeAfterClockAdjustment() {
    let before = sensorTimestampToUnixMicroseconds(
      1000, currentUptime: 1000, currentUnixTime: unixTime)
    // The user sets the wall clock back one minute; the sensor clock does not reset.
    let after = sensorTimestampToUnixMicroseconds(
      1000, currentUptime: 1000, currentUnixTime: unixTime - 60)

    XCTAssertEqual(after - before, -60_000_000, accuracy: accuracyMicroseconds)
  }

}
