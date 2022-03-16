import Foundation
import Network

@available(macOS 10.14, *)
public class PathMonitorConnectivityProvider: NSObject, ConnectivityProvider {
  private let pathMonitor: NWPathMonitor

  private var pathMonitor: NWPathMonitor {
      if (_pathMonitor == nil) {
          _pathMonitor = NWPathMonitor()
      }
      return _pathMonitor!
  }

  public var currentConnectivityType: ConnectivityType {
    let path = pathMonitor.currentPath
    if path.status == .satisfied {
      if path.usesInterfaceType(.wifi) {
        return .wifi
      } else if path.usesInterfaceType(.cellular) {
        return .cellular
      } else if path.usesInterfaceType(.wiredEthernet) {
        return .wiredEthernet
      }
    }
    return .none
  }

  public var connectivityUpdateHandler: ConnectivityUpdateHandler?

  override init() {
    super.init()
    pathMonitor.pathUpdateHandler = pathUpdateHandler
  }

  public func start() {
    pathMonitor.start(queue: .main)
  }

  public func stop() {
    pathMonitor.cancel()
    _pathMonitor = nil
  }

  private func pathUpdateHandler(path: NWPath) {
    connectivityUpdateHandler?(currentConnectivityType)
  }
}
