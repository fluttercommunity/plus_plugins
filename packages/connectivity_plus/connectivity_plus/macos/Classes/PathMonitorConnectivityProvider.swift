import Foundation
import Network

@available(macOS 10.14, *)
public class PathMonitorConnectivityProvider: NSObject, ConnectivityProvider {

  private let queue = DispatchQueue.global(qos: .background)

  private var _pathMonitor: NWPathMonitor?

  public var currentConnectivityTypes: [ConnectivityType] {
    let path = ensurePathMonitor().currentPath
    var types: [ConnectivityType] = []
    
    // Check for connectivity and append to types array as necessary
    if path.status == .satisfied {
      if path.usesInterfaceType(.wifi) {
        types.append(.wifi)
      }
      if path.usesInterfaceType(.cellular) {
        types.append(.cellular)
      }
      if path.usesInterfaceType(.wiredEthernet) {
        types.append(.wiredEthernet)
      }
      if path.usesInterfaceType(.other) {
        types.append(.other)
      }
    }
    
    return types.isEmpty ? [.none] : types
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
    connectivityUpdateHandler?(currentConnectivityTypes)
  }
}
