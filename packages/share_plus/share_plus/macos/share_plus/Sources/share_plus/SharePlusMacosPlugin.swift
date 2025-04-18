import Cocoa
import FlutterMacOS

public class SharePlusMacosPlugin: NSObject, FlutterPlugin, NSSharingServicePickerDelegate {
  private var subject: String?
  private var registrar: FlutterPluginRegistrar

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "dev.fluttercommunity.plus/share", binaryMessenger: registrar.messenger)
    let instance = SharePlusMacosPlugin(registrar: registrar)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as! [String: Any]
    let origin = originRect(args)

    switch call.method {
    case "share":
      let text = args["text"] as? String
      let uri = args["uri"] as? String
      let paths = args["paths"] as? [String]
        
      // Title takes preference over Subject
      // Subject should only be used for email subjects
      // But added for retrocompatibility
      let title = args["title"] as? String
      let subject = title ?? args["subject"] as? String
        
      if let uri = uri {
        shareItems([uri], subject: subject, origin: origin, view: registrar.view!, callback: result)
      } else if let paths = paths {
        let urls = paths.map { NSURL.fileURL(withPath: $0) }
        shareItems(urls, subject: subject, origin: origin, view: registrar.view!, callback: result)
      } else if let text = text {
        shareItems([text], subject: subject, origin: origin, view: registrar.view!, callback: result)
      } else {
        result(FlutterError.init(code: "error", message: "No content to share", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
    sharingService.subject = subject
    return sharingService.delegate
  }

  private func shareItems(_ items: [Any], subject: String? = nil, origin: NSRect, view: NSView, callback: @escaping FlutterResult) {
    DispatchQueue.main.async {
      let picker = NSSharingServicePicker(items: items)
      picker.delegate = SharePlusMacosSuccessDelegate(subject: subject, callback: callback).keep()
      picker.show(relativeTo: origin, of: view, preferredEdge: NSRectEdge.maxY)
    }
  }

  private func originRect(_ args: [String: Any]) -> NSRect {
    let x = CGFloat(args["originX"] as? Double ?? 0)
    let y = CGFloat(args["originY"] as? Double ?? 0)
    let width = CGFloat(args["originWidth"] as? Double ?? 0)
    let height = CGFloat(args["originHeight"] as? Double ?? 0)
    return NSMakeRect(x, y, width, height)
  }
}

/// We need to be able to distinguish between withResult and normal shares.
///
/// With each share having its own delegate, we can assure the correct result
/// is returned to each method call.
class SharePlusMacosSuccessDelegate: NSObject, NSSharingServicePickerDelegate {
  private var subject: String?
  private var callback: FlutterResult
  private var keepSelf: (() -> Void)?

  init(subject: String?, callback: @escaping FlutterResult) {
    self.subject = subject
    self.callback = callback
  }

  /// This will create a reference cycle to keep ourselves alive.
  ///
  /// The delegate on `NSSharingServicePicker` only keeps us as a weak reference
  /// -> we would go out of scope instantly.
  /// Deinit is called after `didChoose` sets `keepSelf` to nil!
  ///
  /// Has to be an extra method as we may not use `self` in a closure in `init`
  public func keep() -> Self {
    self.keepSelf = { _ = self }
    return self
  }

  public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, delegateFor sharingService: NSSharingService) -> NSSharingServiceDelegate? {
    sharingService.subject = subject
    return sharingService.delegate
  }

  public func sharingServicePicker(_ sharingServicePicker: NSSharingServicePicker, didChoose service: NSSharingService?) {
    callback(service != nil ? service!.title : "")
    // Break self referencing cycle -> deinit
    self.keepSelf = nil
  }
}
