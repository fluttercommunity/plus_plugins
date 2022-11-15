import Foundation
import Network

@available(iOS 12, *)
public class PathMonitorConnectivityProvider: NSObject, ConnectivityProvider {

  private let queue = DispatchQueue.global(qos: .background)

  private var _pathMonitor: NWPathMonitor?

  public var currentConnectivityType: ConnectivityType {
    let path = ensurePathMonitor().currentPath
    if path.status == .satisfied {
      if path.usesInterfaceType(.wifi) {
        return .wifi
      } else if path.usesInterfaceType(.cellular) {
        return .cellular
      } else if path.usesInterfaceType(.wiredEthernet) {
        // .wiredEthernet is available in simulator
        // but for consistency it is probably correct to report .wifi
        return .wifi
      } else if path.usesInterfaceType(.other) {
        // path.status == .satisfied means that the network is available
        // and .other is available in simulator
        // for consistency, it would probably be correct to report .vpn
        return .vpn
      }
    }
    return .none
  }

  public var connectivityUpdateHandler: ConnectivityUpdateHandler?

  override init() {
    super.init()
    _ = ensurePathMonitor()
  }

  public func start() {
    _ = ensurePathMonitor()
  }

  public func stop() {
    _pathMonitor?.cancel()
    _pathMonitor = nil
  }

  @discardableResult
  private func ensurePathMonitor() -> NWPathMonitor {
    if (_pathMonitor == nil) {
      let pathMonitor = NWPathMonitor()
      pathMonitor.start(queue: queue)
      pathMonitor.pathUpdateHandler = pathUpdateHandler
      _pathMonitor = pathMonitor
    }
    return _pathMonitor!
  }

  private func pathUpdateHandler(path: NWPath) {
    connectivityUpdateHandler?(currentConnectivityType)
  }
}
