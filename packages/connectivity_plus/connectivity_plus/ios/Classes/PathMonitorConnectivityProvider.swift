import Foundation
import Network

@available(iOS 12, *)
public class PathMonitorConnectivityProvider: NSObject, ConnectivityProvider {
  private let pathMonitor = NWPathMonitor()

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
  }

  private func pathUpdateHandler(path: NWPath) {
    connectivityUpdateHandler?(currentConnectivityType)
  }
}
