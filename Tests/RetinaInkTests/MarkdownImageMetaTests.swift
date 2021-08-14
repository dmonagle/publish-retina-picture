import XCTest
@testable import RetinaInk

final class MarkdownImageMetaTests: XCTestCase {
    func testMarkdownImageMeta() throws {
        let image = try XCTUnwrap(MarkdownImageMeta(markdown: "!(/images/test.jpg?size=large)"))
        XCTAssertEqual(image.url.path, "/images/test.jpg")
        XCTAssertTrue(image.queryKeyExists("size"))
        XCTAssertEqual(image.queryValue(for: "size"), "large")
        XCTAssertNil(image.alt)
    }

    func testMarkdownImageRetina() throws {
        let retinaImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Retina Image](/images/test@2x.jpg)"))
        XCTAssertEqual(retinaImage.url.path, "/images/test@2x.jpg")
        XCTAssertFalse(retinaImage.queryKeyExists("dark"))
        XCTAssertEqual(retinaImage.alt, "Retina Image")
    }

    func testMarkdownImageMetaDark() throws {
        let darkImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Dark Image](/images/test.jpg?dark)"))
        XCTAssertEqual(darkImage.url.path, "/images/test.jpg")
        XCTAssertTrue(darkImage.queryKeyExists("dark"))
        XCTAssertEqual(darkImage.alt, "Dark Image")
    }

    func testMarkdownImageMetaRetinaDark() throws {
        let darkRetinaImage = try XCTUnwrap(MarkdownImageMeta(markdown: "![Dark Retina Image](/images/test@2x.jpg?dark)"))
        XCTAssertEqual(darkRetinaImage.url.path, "/images/test@2x.jpg")
        XCTAssertTrue(darkRetinaImage.queryKeyExists("dark"))
        XCTAssertEqual(darkRetinaImage.alt, "Dark Retina Image")
    }
}
