import XCTest
@testable import PublishPicturePlugin

final class PublishPicturePluginTests: XCTestCase {
    func testMarkdownImageMeta() throws {
        let darkRetinaImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Dark Retina Image](/images/test@2x.jpg?dark)"))
        XCTAssertEqual(darkRetinaImage.url.path, "/images/test@2x.jpg")
        XCTAssertTrue(darkRetinaImage.queryKeyExists("dark"))
        XCTAssertEqual(darkRetinaImage.alt, "Dark Retina Image")

        let retinaImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Retina Image](/images/test@2x.jpg)"))
        XCTAssertEqual(retinaImage.url.path, "/images/test@2x.jpg")
        XCTAssertFalse(retinaImage.queryKeyExists("dark"))
        XCTAssertEqual(retinaImage.alt, "Retina Image")

        let darkImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Dark Image](/images/test.jpg?dark)"))
        XCTAssertEqual(darkImage.url.path, "/images/test.jpg")
        XCTAssertTrue(darkImage.queryKeyExists("dark"))
        XCTAssertEqual(darkImage.alt, "Dark Image")

        let image = try XCTUnwrap(MarkdownImageMeta(markdown: "!(/images/test.jpg?size=large)"))
        XCTAssertEqual(image.url.path, "/images/test.jpg")
        XCTAssertTrue(image.queryKeyExists("size"))
        XCTAssertEqual(image.queryValue(for: "size"), "large")
        XCTAssertNil(image.alt)
    }
    
    func testRetinaImagePath() throws {
        let retinaImage: RetinaImagePath = "/images/knowledge/goals-list.jpeg"
        XCTAssertEqual(retinaImage.originalScale, 1)
        XCTAssertEqual(retinaImage.retinaURL(scale: 1).absoluteString, "file:/images/knowledge/goals-list.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 2).absoluteString, "file:/images/knowledge/goals-list@2x.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 3).absoluteString, "file:/images/knowledge/goals-list@3x.jpeg")
    }

    func testRetinaImagePathOn1x() throws {
        let retinaImage: RetinaImagePath = "/images/knowledge/goals-list@1x.jpeg"
        XCTAssertEqual(retinaImage.originalScale, 1)
        XCTAssertEqual(retinaImage.retinaURL(scale: 1).absoluteString, "file:/images/knowledge/goals-list.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 2).absoluteString, "file:/images/knowledge/goals-list@2x.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 3).absoluteString, "file:/images/knowledge/goals-list@3x.jpeg")
    }

    func testRetinaImagePathOn2x() throws {
        let retinaImage: RetinaImagePath = "/images/knowledge/goals-list@2x.jpeg"
        XCTAssertEqual(retinaImage.originalScale, 2)
        XCTAssertEqual(retinaImage.retinaURL(scale: 1).absoluteString, "file:/images/knowledge/goals-list.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 2).absoluteString, "file:/images/knowledge/goals-list@2x.jpeg")
        XCTAssertEqual(retinaImage.retinaURL(scale: 3).absoluteString, "file:/images/knowledge/goals-list@3x.jpeg")
    }

    static var allTests = [
        ("testMarkdownImageMeta", testMarkdownImageMeta),
    ]
}
