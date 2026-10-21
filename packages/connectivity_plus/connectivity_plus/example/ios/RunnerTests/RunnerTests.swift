import Flutter
import UIKit
import XCTest

@testable import connectivity_plus

private class FakeConnectivityProvider: NSObject, ConnectivityProvider {
  var currentConnectivityTypes: [ConnectivityType] = [.wifi]
  var connectivityUpdateHandler: ConnectivityUpdateHandler?

  func start() {}

  func stop() {}

  func pathChanged(to connectivityTypes: [ConnectivityType]) {
    currentConnectivityTypes = connectivityTypes
    connectivityUpdateHandler?(connectivityTypes)
  }
}

class RunnerTests: XCTestCase {
  private var provider: FakeConnectivityProvider!
  private var notificationCenter: NotificationCenter!
  private var applicationState: UIApplication.State = .active
  private var events: [[String]] = []
  private var plugin: ConnectivityPlusPlugin!

  override func setUp() {
    super.setUp()
    provider = FakeConnectivityProvider()
    notificationCenter = NotificationCenter()
    applicationState = .active
    events = []
    plugin = ConnectivityPlusPlugin(
      connectivityProvider: provider,
      applicationState: { [unowned self] in self.applicationState },
      notificationCenter: notificationCenter)
    listen()
  }

  /// The plugin emits from `DispatchQueue.main.async`: wait until the blocks queued so far have
  /// run.
  private func drainMainQueue() {
    let drained = expectation(description: "main queue drained")
    DispatchQueue.main.async { drained.fulfill() }
    wait(for: [drained], timeout: 5)
  }

  private func listen() {
    _ = plugin.onListen(withArguments: nil) { [unowned self] event in
      self.events.append(event as! [String])
    }
    drainMainQueue()
  }

  private func becomeActive() {
    applicationState = .active
    notificationCenter.post(name: UIApplication.didBecomeActiveNotification, object: nil)
    drainMainQueue()
  }

  func testEmitsTheCurrentConnectivityOnListen() {
    XCTAssertEqual(events, [["wifi"]])
  }

  func testEmitsChangesWhileInTheForeground() {
    provider.pathChanged(to: [.cellular])
    drainMainQueue()

    XCTAssertEqual(events, [["wifi"], ["mobile"]])
  }

  func testDoesNotEmitWhileInTheBackground() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()

    XCTAssertEqual(events, [["wifi"]])
  }

  func testEmitsTheLatestChangeMissedInTheBackgroundOnceActive() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    provider.pathChanged(to: [.none])
    drainMainQueue()

    becomeActive()

    XCTAssertEqual(events, [["wifi"], ["none"]])
  }

  func testEmitsTheCurrentPathOnceActiveWhenANewerUpdateIsStillQueued() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()
    // NWPathMonitor already reports the new path; its update has not reached the plugin yet.
    provider.currentConnectivityTypes = [.wifi]

    becomeActive()

    XCTAssertEqual(events, [["wifi"], ["wifi"]])
  }

  func testEmitsAMissedChangeOnlyOnce() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()

    becomeActive()
    becomeActive()

    XCTAssertEqual(events, [["wifi"], ["mobile"]])
  }

  func testDoesNotEmitOnBecomingActiveWithoutAMissedChange() {
    becomeActive()

    XCTAssertEqual(events, [["wifi"]])
  }

  func testDropsAMissedChangeSupersededInTheForeground() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()
    applicationState = .inactive
    provider.pathChanged(to: [.wifi])
    drainMainQueue()

    becomeActive()

    XCTAssertEqual(events, [["wifi"], ["wifi"]])
  }

  func testDoesNotEmitAMissedChangeAfterCancel() {
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()

    _ = plugin.onCancel(withArguments: nil)
    becomeActive()

    XCTAssertEqual(events, [["wifi"]])
  }

  func testEmitsAMissedChangeAfterListeningAgain() {
    _ = plugin.onCancel(withArguments: nil)
    listen()
    applicationState = .background
    provider.pathChanged(to: [.cellular])
    drainMainQueue()

    becomeActive()

    XCTAssertEqual(events, [["wifi"], ["wifi"], ["mobile"]])
  }

  func testEmitsTheConnectivityOnceActiveWhenListeningInTheBackground() {
    _ = plugin.onCancel(withArguments: nil)
    events = []
    applicationState = .background
    listen()

    XCTAssertEqual(events, [])

    becomeActive()

    XCTAssertEqual(events, [["wifi"]])
  }
}
