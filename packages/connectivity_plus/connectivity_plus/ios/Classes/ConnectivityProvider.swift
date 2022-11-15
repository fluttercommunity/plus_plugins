import Foundation

public enum ConnectivityType {
  case none
  case wiredEthernet
  case wifi
  case cellular
  case vpn
}

public protocol ConnectivityProvider: NSObjectProtocol {
  typealias ConnectivityUpdateHandler = (ConnectivityType) -> Void

  var currentConnectivityType: ConnectivityType { get }

  var connectivityUpdateHandler: ConnectivityUpdateHandler? { get set }

  func start()

  func stop()
}
