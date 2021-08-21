// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Cocoa
import FlutterMacOS
import Network
import SystemConfiguration.CaptiveNetwork

public class ConnectivityPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  var pathMonitor = NWPathMonitor()

  override init() {
    super.init()
    pathMonitor.pathUpdateHandler = pathUpdateHandler
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.fluttercommunity.plus/connectivity",
      binaryMessenger: registrar.messenger)

    let streamChannel = FlutterEventChannel(
      name: "dev.fluttercommunity.plus/connectivity_status",
      binaryMessenger: registrar.messenger)

    let instance = ConnectivityPlugin()
    streamChannel.setStreamHandler(instance)

    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "check":
      result(statusFromPath(path: pathMonitor.currentPath))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Returns a string describing connection type
  ///
  /// - Parameters:
  ///   - path: an instance of NWPath
  /// - Returns: connection type string
  private func statusFromPath(path: NWPath) -> String {
    if path.status == .satisfied {
        if path.usesInterfaceType(.wifi) {
            return "wifi"
        } else if path.usesInterfaceType(.cellular) {
            return "mobile"
        } else if path.usesInterfaceType(.wiredEthernet) {
            return "ethernet"
        }
    }
    return "none"
  }

  public func onListen(
    withArguments _: Any?,
    eventSink events: @escaping FlutterEventSink
  ) -> FlutterError? {
    eventSink = events
    pathMonitor.start(queue: .global(qos: .background))
    return nil
  }

  private func pathUpdateHandler(path: NWPath) {
    eventSink?(statusFromPath(path: path))
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    pathMonitor.cancel()
    eventSink = nil
    return nil
  }
}
