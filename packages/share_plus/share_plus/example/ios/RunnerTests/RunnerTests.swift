import LinkPresentation
import UIKit
import XCTest

class RunnerTests: XCTestCase {

  @MainActor
  func testLinkPayloadRemainsAURL() throws {
    let item = try makeLinkItem(title: "Product title", subject: "Email subject")
    let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
    XCTAssertEqual(item.activityViewControllerPlaceholderItem(controller) as? URL, link)
    for activity in [UIActivity.ActivityType.mail, .copyToPasteboard, nil] {
      XCTAssertEqual(
        item.activityViewController(controller, itemForActivityType: activity) as? URL, link)
    }
  }

  @MainActor
  func testLinkPreviewTitleAndEmailSubjectAreIndependent() throws {
    let item = try makeLinkItem(title: "Product title", subject: "Email subject")
    let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
    let metadata = try XCTUnwrap(item.activityViewControllerLinkMetadata?(controller))
    XCTAssertEqual(metadata.title, "Product title")
    XCTAssertEqual(metadata.url, link)
    XCTAssertEqual(metadata.originalURL, link)
    XCTAssertEqual(
      item.activityViewController?(controller, subjectForActivityType: .mail), "Email subject")
  }

  @MainActor
  func testLinkPreviewFallsBackToSubjectThenURL() throws {
    let cases: [(String?, String?, String)] = [
      (nil, "Email subject", "Email subject"),
      ("", "Email subject", "Email subject"),
      (nil, nil, link.absoluteString),
      ("", "", link.absoluteString),
    ]
    for (title, subject, expectedTitle) in cases {
      let item = try makeLinkItem(title: title, subject: subject)
      let controller = UIActivityViewController(activityItems: [item], applicationActivities: nil)
      let metadata = try XCTUnwrap(item.activityViewControllerLinkMetadata?(controller))
      XCTAssertEqual(metadata.title, expectedTitle)
      XCTAssertEqual(
        item.activityViewController?(controller, subjectForActivityType: .mail), subject)
    }
  }

  private let link = URL(string: "https://example.com/product?id=123")!

  private func makeLinkItem(title: String?, subject: String?) throws -> UIActivityItemSource {
    let itemClass = try XCTUnwrap(NSClassFromString("SharePlusLinkData") as? NSObject.Type)
    let item = itemClass.init()
    item.setValue(link, forKey: "url")
    item.setValue(title, forKey: "title")
    item.setValue(subject, forKey: "subject")
    return try XCTUnwrap(item as? UIActivityItemSource)
  }
}
