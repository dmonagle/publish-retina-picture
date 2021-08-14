import XCTest
@testable import RetinaPicture

final class RetinaImagePathTests: XCTestCase {
    func testImagePath() throws {
        let path: RetinaImagePath = "/images/logo.png"
        
        XCTAssertEqual(path.retinaURL().path, "/images/logo.png")
        XCTAssertEqual(path.retinaURL(scale: 2).path, "/images/logo@2x.png")
        XCTAssertEqual(path.retinaURL(scale: 2, suffix: "-dark").path, "/images/logo-dark@2x.png")
    }

    func testImagePathWithRetinaSize() throws {
        let path: RetinaImagePath = "/images/avatar@3x.png"
        
        XCTAssertEqual(path.retinaURL().path, "/images/avatar.png")
        XCTAssertEqual(path.retinaURL(scale: 2).path, "/images/avatar@2x.png")
        XCTAssertEqual(path.retinaURL(scale: 2, suffix: "-dark").path, "/images/avatar-dark@2x.png")
    }
}
