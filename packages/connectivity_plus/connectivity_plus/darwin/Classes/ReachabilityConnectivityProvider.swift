import Foundation
import Reachability

public class ReachabilityConnectivityProvider: NSObject, ConnectivityProvider {
  private var reachability: Reachability?

  public var currentConnectivityTypes: [ConnectivityType] {
    guard let reachability = reachability else {
      return [.none]
    }
    
    // Supported types https://github.com/ashleymills/Reachability.swift/blob/master/Sources/Reachability.swift#L99
    switch reachability.connection {
    case .wifi:
      return [.wifi]
    case .cellular:
      return [.cellular]
    default:
      return [.none]
    }
  }

  public var connectivityUpdateHandler: ConnectivityUpdateHandler?

  override init() {
    super.init()
    _ = ensureReachability()
  }

  public func start() {
    let reachability = ensureReachability()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(reachabilityChanged),
      name: .reachabilityChanged,
      object: reachability)

    try? reachability.startNotifier()
  }

  public func stop() {
    NotificationCenter.default.removeObserver(
      self,
      name: .reachabilityChanged,
      object: reachability)

    reachability?.stopNotifier()
    reachability = nil
  }

  private func ensureReachability() -> Reachability {
    if (reachability == nil) {
      let reachability = try? Reachability()
      self.reachability = reachability
    }
    return reachability!
  }

  @objc private func reachabilityChanged(notification: NSNotification) {
    if let reachability = notification.object as? Reachability {
      self.reachability = reachability
      connectivityUpdateHandler?(currentConnectivityTypes)
    }
  }
}
