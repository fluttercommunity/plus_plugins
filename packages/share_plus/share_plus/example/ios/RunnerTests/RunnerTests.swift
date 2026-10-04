import Flutter
import UIKit
import XCTest
import share_plus

class RunnerTests: XCTestCase {

  @MainActor
  func testUriSharePreservesSubject() throws {
    let controller = try shareUri(subject: "Subject for Mail")
    XCTAssertEqual(controller.value(forKey: "subject") as? String, "Subject for Mail")
  }

  @MainActor
  func testUriShareUsesTitleBeforeLegacySubject() throws {
    let controller = try shareUri(subject: "Legacy subject", title: "Share title")
    XCTAssertEqual(controller.value(forKey: "subject") as? String, "Share title")
  }

  @MainActor
  func testUriShareWithoutSubject() throws {
    let controller = try shareUri()
    XCTAssertNil(controller.value(forKey: "subject"))
  }

  @MainActor
  private func shareUri(subject: String? = nil, title: String? = nil) throws
    -> UIActivityViewController
  {
    let scene = try XCTUnwrap(UIApplication.shared.connectedScenes.first as? UIWindowScene)
    let window = try XCTUnwrap(scene.windows.first(where: { $0.isKeyWindow }))
    let previousController = window.rootViewController
    let presenter = RecordingViewController()
    window.rootViewController = presenter
    defer { window.rootViewController = previousController }

    let engine = RecordingEngine(name: "share-plus-subject-test")
    let registrar = try XCTUnwrap(engine.registrar(forPlugin: "share-plus-subject-test"))
    FPPSharePlusPlugin.register(with: registrar)
    let handler = try XCTUnwrap(engine.recorder.handler)
    var arguments: [String: Any] = [
      "uri": "https://example.test/link",
      "originX": 1.0, "originY": 1.0, "originWidth": 20.0, "originHeight": 20.0,
    ]
    if let subject { arguments["subject"] = subject }
    if let title { arguments["title"] = title }
    let call = FlutterMethodCall(methodName: "share", arguments: arguments)
    handler(FlutterStandardMethodCodec.sharedInstance().encode(call)) { _ in
      XCTFail("Sharing should wait for the activity to complete")
    }
    return try XCTUnwrap(presenter.activityController)
  }
}

private final class RecordingEngine: FlutterEngine {
  let recorder = RecordingMessenger()

  override var binaryMessenger: FlutterBinaryMessenger { recorder }
}

private final class RecordingMessenger: NSObject, FlutterBinaryMessenger {
  var handler: FlutterBinaryMessageHandler?

  func send(onChannel channel: String, message: Data?) {}
  func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply?) {}
  func cleanUpConnection(_ connection: FlutterBinaryMessengerConnection) {}

  func setMessageHandlerOnChannel(
    _ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler?
  ) -> FlutterBinaryMessengerConnection {
    if channel == "dev.fluttercommunity.plus/share" { self.handler = handler }
    return 1
  }
}

private final class RecordingViewController: UIViewController {
  var activityController: UIActivityViewController?

  override func present(
    _ viewControllerToPresent: UIViewController, animated flag: Bool,
    completion: (() -> Void)? = nil
  ) {
    activityController = viewControllerToPresent as? UIActivityViewController
  }
}
