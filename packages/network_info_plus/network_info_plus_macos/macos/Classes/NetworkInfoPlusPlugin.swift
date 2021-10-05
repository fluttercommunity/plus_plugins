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
import CoreWLAN
import FlutterMacOS
import SystemConfiguration.CaptiveNetwork


public class NetworkInfoPlusPlugin: NSObject, FlutterPlugin {
  var cwinterface: CWInterface?

  public override init() {
    cwinterface = CWWiFiClient.shared().interface()
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "dev.fluttercommunity.plus/network_info",
      binaryMessenger: registrar.messenger)

    let instance = NetworkInfoPlusPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "wifiName":
      result(cwinterface?.ssid())
    case "wifiBSSID":
      result(cwinterface?.bssid())
    case "wifiIPAddress":
        result(getWiFiAddress(family: AF_INET))
    case "wifiIPv6Address":
        result(getWiFiAddress(family: AF_INET6))
    case "wifiSubmask":
        result("")
    case "wifiBroadcast":
        result("")
    case "wifiGatewayAddress":
        result("")
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

// Return IP address of WiFi interface (en0) as a String, or `nil`
func getWiFiAddress(family: Int32) -> String? {
    var address : String?

    // Get list of all interfaces on the local machine:
    var ifaddr : UnsafeMutablePointer<ifaddrs>?
    guard getifaddrs(&ifaddr) == 0 else { return nil }
    guard let firstAddr = ifaddr else { return nil }

    // For each interface ...
    for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
        let interface = ifptr.pointee

        // Check for IPv4 or IPv6 interface:
        let addrFamily = interface.ifa_addr.pointee.sa_family
        if addrFamily == UInt8(family) {

            // Check interface name:
            let name = String(cString: interface.ifa_name)
            if  name == "en0" {

                // Convert interface address to a human readable string:
                var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                            &hostname, socklen_t(hostname.count),
                            nil, socklen_t(0), NI_NUMERICHOST)
                address = String(cString: hostname)
            }
        }
    }
    freeifaddrs(ifaddr)

    return address
}

