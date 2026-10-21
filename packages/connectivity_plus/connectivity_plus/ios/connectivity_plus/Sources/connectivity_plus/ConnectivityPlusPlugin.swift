// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source is governed by a BSD-style license that can
// be found in the LICENSE file.

import Flutter
import UIKit

public class ConnectivityPlusPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  private let connectivityProvider: ConnectivityProvider
  private let applicationState: @MainActor () -> UIApplication.State
  private var eventSink: FlutterEventSink?
  /// Whether an update was dropped while the app was in the background: the current
  /// connectivity is emitted once the app becomes active again. Only touched on the main queue.
  private var missedUpdate = false

  init(
    connectivityProvider: ConnectivityProvider,
    applicationState: @escaping @MainActor () -> UIApplication.State = {
      UIApplication.shared.applicationState
    },
    notificationCenter: NotificationCenter = .default
  ) {
    self.connectivityProvider = connectivityProvider
    self.applicationState = applicationState
    super.init()
    self.connectivityProvider.connectivityUpdateHandler = { [weak self] connectivityTypes in
      self?.connectivityUpdateHandler(connectivityTypes: connectivityTypes)
    }
    notificationCenter.addObserver(
      self,
      selector: #selector(applicationDidBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil)
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let binaryMessenger = registrar.messenger()

    let channel = FlutterMethodChannel(
      name: "dev.fluttercommunity.plus/connectivity",
      binaryMessenger: binaryMessenger)

    let streamChannel = FlutterEventChannel(
      name: "dev.fluttercommunity.plus/connectivity_status",
      binaryMessenger: binaryMessenger)

    let connectivityProvider = PathMonitorConnectivityProvider()
    let instance = ConnectivityPlusPlugin(connectivityProvider: connectivityProvider)
    streamChannel.setStreamHandler(instance)

    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.publish(instance)
  }

  public func detachFromEngine(for registrar: FlutterPluginRegistrar) {
    eventSink = nil
    missedUpdate = false
    connectivityProvider.stop()
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "check":
      result(statusFrom(connectivityTypes: connectivityProvider.currentConnectivityTypes))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func statusFrom(connectivityType: ConnectivityType) -> String {
    switch connectivityType {
    case .wifi:
      return "wifi"
    case .cellular:
      return "mobile"
    case .wiredEthernet:
      return "ethernet"
    case .satellite:
      return "satellite"
    case .other:
        return "other"
    case .none:
      return "none"
    }
  }
  
  private func statusFrom(connectivityTypes: [ConnectivityType]) -> [String] {
    return connectivityTypes.map {
      self.statusFrom(connectivityType: $0)
    }
  }

  public func onListen(
    withArguments _: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    connectivityProvider.start()
    // Update this to handle a list
    connectivityUpdateHandler(connectivityTypes: connectivityProvider.currentConnectivityTypes)
    return nil
  }

  private func connectivityUpdateHandler(connectivityTypes: [ConnectivityType]) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self, let eventSink = self.eventSink else { return }
      // NWPathMonitor can fire while the app is in the background, after the
      // FlutterEngine's shell has been torn down. Calling eventSink in that
      // state triggers an NSAssertion in -[FlutterEngine sendOnChannel:] and
      // crashes the app with SIGABRT. Skip the emission, and emit the current
      // connectivity once the app becomes active again: a listener that stays
      // subscribed gets no new onListen, so it would otherwise keep the state
      // from before.
      guard self.applicationState() != .background else {
        self.missedUpdate = true
        return
      }
      self.missedUpdate = false
      eventSink(self.statusFrom(connectivityTypes: connectivityTypes))
    }
  }

  @objc private func applicationDidBecomeActive() {
    guard missedUpdate, let eventSink = eventSink else { return }
    missedUpdate = false
    // The current path rather than the dropped one: a newer update may still be queued.
    eventSink(statusFrom(connectivityTypes: connectivityProvider.currentConnectivityTypes))
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    connectivityProvider.stop()
    eventSink = nil
    missedUpdate = false
    return nil
  }
}
