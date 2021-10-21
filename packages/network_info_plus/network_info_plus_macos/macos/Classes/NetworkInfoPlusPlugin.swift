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
      result(getWifiAddress(family: AF_INET))
    case "wifiIPv6Address":
      result(getWifiAddress(family: AF_INET6))
    case "wifiSubmask":
      result(getWifiSubmask())
    case "wifiBroadcast":
      result(getWifiBroadcast())
    case "wifiGatewayAddress":
      result(getDefaultGateway())
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func getWifiAddress(family: Int32) -> String? {
    return withWifiInterface(family: family) { descriptionForAddress($0.pointee.ifa_addr) }
  }

  public func getWifiSubmask() -> String? {
    return withWifiInterface(family: AF_INET) { descriptionForAddress($0.pointee.ifa_netmask) }
  }

  public func getWifiBroadcast() -> String? {
    return withWifiInterface(family: AF_INET) { descriptionForAddress($0.pointee.ifa_dstaddr) }
  }

  public func getDefaultGateway() -> String? {
    var mib : [Int32] = [CTL_NET, PF_ROUTE, 0, AF_INET, NET_RT_FLAGS, RTF_GATEWAY];
    var l : Int = 0
    guard sysctl(&mib, UInt32(mib.count), nil, &l, nil, 0) == 0 else { return nil }

    var buf = [UInt8](repeating: 0, count: l)
    guard sysctl(&mib, UInt32(mib.count), &buf, &l, nil, 0) == 0 else { return nil }

    return buf.withUnsafeBytes { buf in
      var result : String?

      var sa_tab = [UnsafePointer<sockaddr>?](repeating: nil, count: Int(RTAX_MAX))

      var p = buf.baseAddress!
      while p < buf.baseAddress! + l {
        let rt = p.bindMemory(to: rt_msghdr.self, capacity: 1)
        var sa = (UnsafeRawPointer(rt) + Int(MemoryLayout<rt_msghdr>.stride)).bindMemory(to: sockaddr.self, capacity: 1)

        for i in 0..<Int(RTAX_MAX) {
          if rt.pointee.rtm_addrs & (1 << i) != 0 {
            sa_tab[i] = sa
            sa = (UnsafeRawPointer(sa) + roundup(Int(sa.pointee.sa_len))).bindMemory(to: sockaddr.self, capacity: 1)
          } else {
            sa_tab[i] = nil
          }
        }

        if rt.pointee.rtm_addrs & (RTA_DST | RTA_GATEWAY) != 0,
           let sa_dst = sa_tab[Int(RTAX_DST)], let sa_gateway = sa_tab[Int(RTAX_GATEWAY)],
           sa_dst.pointee.sa_family == AF_INET && sa_gateway.pointee.sa_family == AF_INET {

          var ifname = [CChar](repeating: 0, count: 128)
          if_indextoname(UInt32(rt.pointee.rtm_index), &ifname)
          if String(cString: ifname) == "en0" {
            result = descriptionForAddress(sa_gateway)
          }
        }

        p += Int(rt.pointee.rtm_msglen)
      }

      return result
    }
  }
}

/// Calls the given closure with a pointer to Wi-Fi interface (`en0`). For
/// compatibility reasons it can be called multiple times.
///
/// - parameter family: One of `AF_INET` or `AF_INET6`
/// - parameter body: A closure with `UnsafePointer<ifaddrs>` parameter that
/// points to the found Wi-Fi interface. The argument is valid only for the
/// duration of the closure's execution.
/// - returns: The result of last call to `body` or `nil` if there was no `en0`
/// interface found.
func withWifiInterface<R>(family: Int32, body: (UnsafePointer<ifaddrs>) throws -> R) rethrows -> R? {
  var result : R?

  // Get list of all interfaces on the local machine:
  var ifaddr : UnsafeMutablePointer<ifaddrs>?
  guard getifaddrs(&ifaddr) == 0 else { return nil }
  guard let firstAddr = ifaddr else { return nil }

  defer { freeifaddrs(ifaddr) }

  // For each interface ...
  for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
    let interface = ifptr.pointee

    // Check for IPv4 or IPv6 interface:
    let addrFamily = interface.ifa_addr.pointee.sa_family
    if addrFamily == UInt8(family) {

      // Check interface name:
      let name = String(cString: interface.ifa_name)
      if  name == "en0" {

        result = try body(ifptr)
      }
    }
  }

  return result
}

private func descriptionForAddress(_ addr : UnsafePointer<sockaddr>) -> String{
  var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
  getnameinfo(addr, socklen_t(addr.pointee.sa_len),
              &hostname, socklen_t(hostname.count),
              nil, socklen_t(0), NI_NUMERICHOST)
  return String(cString: hostname)
}

private func roundup(_ a: Int) -> Int {
  return a > 0 ? (1 + ((a - 1) | (MemoryLayout<CLong>.stride - 1))) : MemoryLayout<CLong>.stride
}
