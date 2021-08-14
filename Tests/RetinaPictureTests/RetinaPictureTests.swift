//
//  RetinaPictureTests.swift
//
//
//  Created by David Monagle on 14/8/21.
//

import XCTest

@testable import RetinaPicture

import Plot

final class RetinaPictureTests: XCTestCase {
    func testRetinaImgNode() {
        let path: RetinaImagePath = "/images/logo.png"

        let node = Node<HTML.PictureContext>.img(path)
        
        XCTAssertEqual(node.render(), #"<img src="/images/logo.png"/>"#)
    }

    func testRetinaImgNodeWithAttribute() {
        let path: RetinaImagePath = "/images/logo.png"

        let node = Node<HTML.PictureContext>.img(path, .class("exciting"))
        
        XCTAssertEqual(node.render(), #"<img class="exciting" src="/images/logo.png"/>"#)
    }

    func testRetinaSourcesNodeWithStandardImage() {
        let path: RetinaImagePath = "/images/logo.png"

        let node = Node<HTML.PictureContext>.sources(path, includeDark: false)
        
        XCTAssertEqual(node.render(), #"<source srcset="/images/logo.png 1x"></source>"#)
    }

    func testRetinaSourcesNodeWith3xImage() {
        let path: RetinaImagePath = "/images/logo@3x.png"

        let node = Node<HTML.PictureContext>.sources(path, includeDark: false)
        
        XCTAssertEqual(node.render(), #"<source srcset="/images/logo.png 1x,/images/logo@2x.png 2x,/images/logo@3x.png 3x"></source>"#)
    }

    func testRetinaSourcesNodeWith2xDarkImage() {
        let path: RetinaImagePath = "/images/logo@2x.png"

        let node = Node<HTML.PictureContext>.sources(path, includeDark: true)
        
        XCTAssertEqual(node.render(), #"<source srcset="/images/logo.png 1x,/images/logo@2x.png 2x" media="(prefers-color-scheme: light)"></source><source srcset="/images/logo-dark.png 1x,/images/logo-dark@2x.png 2x" media="(prefers-color-scheme: dark)"></source>"#)
    }

    func testRetinaPictureComponent() {
        let path: RetinaImagePath = "/images/logo@2x.png"
        
        let component = RetinaPicture(path, includeDark: true, description: "A retina logo")
        
        XCTAssertEqual(component.render(), #"<picture><source srcset="/images/logo.png 1x,/images/logo@2x.png 2x" media="(prefers-color-scheme: light)"></source><source srcset="/images/logo-dark.png 1x,/images/logo-dark@2x.png 2x" media="(prefers-color-scheme: dark)"></source><img src="/images/logo.png" alt="A retina logo"/></picture>"#)
    }

    func testRetinaPictureComponentWithImageCustomization() {
        let path: RetinaImagePath = "/images/logo@2x.png"
        
        let component = RetinaPicture(path, includeDark: true, description: "A retina logo") { image in
            image.class("exciting")
        }
        
        XCTAssertEqual(component.render(), #"<picture><source srcset="/images/logo.png 1x,/images/logo@2x.png 2x" media="(prefers-color-scheme: light)"></source><source srcset="/images/logo-dark.png 1x,/images/logo-dark@2x.png 2x" media="(prefers-color-scheme: dark)"></source><img src="/images/logo.png" alt="A retina logo" class="exciting"/></picture>"#)
    }
}
