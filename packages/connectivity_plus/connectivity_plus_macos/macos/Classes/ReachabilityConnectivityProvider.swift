import Foundation
import Reachability

public class ReachabilityConnectivityProvider: NSObject, ConnectivityProvider {
  private var reachability: Reachability?

  public var currentConnectivityType: ConnectivityType {
    let reachability = try? self.reachability ?? Reachability()
    switch reachability?.connection ?? .unavailable {
    case .wifi:
      return .wifi
    case .cellular:
      return .cellular
    default:
      return .none
    }
  }

  public var connectivityUpdateHandler: ConnectivityUpdateHandler?

  public func start() {
    reachability = try? Reachability()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(reachabilityChanged),
      name: .reachabilityChanged,
      object: reachability)

    try? reachability?.startNotifier()
  }

  public func stop() {
    NotificationCenter.default.removeObserver(
      self,
      name: .reachabilityChanged,
      object: reachability)

    reachability?.stopNotifier()
    reachability = nil
  }

  @objc private func reachabilityChanged(notification: NSNotification) {
    connectivityUpdateHandler?(currentConnectivityType)
  }
}
