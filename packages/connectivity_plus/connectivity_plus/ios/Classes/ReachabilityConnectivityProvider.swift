import Foundation
import Reachability

public class ReachabilityConnectivityProvider: NSObject, ConnectivityProvider {
  private var _reachability: Reachability?

  public var currentConnectivityTypes: [ConnectivityType] {
    guard let reachability = _reachability else {
      return [.none]
    }
    
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
      object: _reachability)

    _reachability?.stopNotifier()
    _reachability = nil
  }

  private func ensureReachability() -> Reachability {
    if (_reachability == nil) {
      let reachability = try? Reachability()
      _reachability = reachability
    }
    return _reachability!
  }

  @objc private func reachabilityChanged(notification: NSNotification) {
    if let reachability = notification.object as? Reachability {
      _reachability = reachability
      connectivityUpdateHandler?(currentConnectivityTypes)
    }
  }
}
