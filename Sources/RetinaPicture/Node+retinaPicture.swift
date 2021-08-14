//
//  Node+retinaPicture.swift
//  
//
//  Created by David Monagle on 16/6/20.
//

import Plot
import Foundation

// MARK: - Public Extensions

public extension Node where Context: HTML.BodyContext {
    /// Add a `<picture>` HTML element containing all of the permutations for the `retinaImage`.
    /// - Parameters:
    ///   - retinaImage: The `RetinaImagePath` to use for the creation of `<sources>` and `<img>` elements
    ///   - includeDark: If true, a dark variation will be inserted with a suffix of -dark on the image
    ///   - alt: The alt description for the contained `<img>` element
    ///   - imgAttributes: Additional attributes to add to the contained `<img>` element
    /// - Returns: A `<picture>` `Node` element
    ///
    /// Note that any additional attributes passed to this function are inserted in the embedded `<img>` element and not on the created `<picture>` element.
    static func picture(retinaImage: RetinaImagePath, includeDark: Bool = false, alt: String? = nil, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        .picture(retinaImage: retinaImage, includeDark: includeDark, alt: alt, imgAttributes: imgAttributes)
    }
    
    /// Add a `<picture>` HTML element containing all of the permutations for the `retinaImage`.
    /// - Parameters:
    ///   - path: The path to the retina image to use for the creation of `<sources>` and `<img>` elements
    ///   - includeDark: If true, a dark variation will be inserted with a suffix of -dark on the image
    ///   - alt: The alt description for the contained `<img>` element
    ///   - imgAttributes: Additional attributes to add to the contained `<img>` element
    /// - Returns: A `<picture>` `Node` element
    static func retinaPicture(path: String, includeDark: Bool = false, alt: String? = nil, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        .retinaPicture(path: path, includeDark: includeDark, alt: alt, imgAttributes: imgAttributes)
    }
    
    /// Add a `<picture>` HTML element containing all of the permutations for the `retinaImage`.
    /// - Parameters:
    ///   - path: The path to the retina image to use for the creation of `<sources>` and `<img>` elements
    ///   - includeDark: If true, a dark variation will be inserted with a suffix of -dark on the image
    ///   - alt: The alt description for the contained `<img>` element
    ///   - imgAttributes: Additional attributes to add to the contained `<img>` element
    /// - Returns: A `<picture>` `Node` element
    static func retinaPicture(path: String, includeDark: Bool = false, alt: String? = nil, imgAttributes: [Attribute<HTML.ImageContext>]) -> Node {
        .picture(retinaImage: RetinaImagePath(stringLiteral: path), includeDark: includeDark, alt: alt, imgAttributes: imgAttributes)
    }
}


public extension Node where Context : HTMLImageContainerContext {
    /// Add an `<img>` element for the `retinaImage`
    /// - Parameters:
    ///   - retinaImage: The `RetinaImagePath` to use for the src attribute of the `<img>` element
    ///   - alt: Content for the alt attribute
    ///   - imgAttributes: Additional attributes for the `<img>` element
    /// - Returns:  A `<img>` `Node` element
    ///
    /// Note that any additional attributes passed to this function are inserted in the embedded `<img>` element and not on the created `<picture>` element.
    static func img(_ retinaImage: RetinaImagePath, alt: String? = nil, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        img(retinaImage, alt: alt, imgAttributes: imgAttributes)
    }
}

public extension Node where Context == HTML.PictureContext {
    /// Returns a source element containing a srcset for each of the retina image permutations
    static func sources(_ imagePath: RetinaImagePath, includeDark: Bool = false) -> Node {
        var sources: [Node<HTML.PictureContext>] = [
            .element(named: "source", nodes: [
                .attribute(named: "srcset", value: imagePath.srcset()),
                .if(includeDark, .attribute(named: "media", value: "(prefers-color-scheme: light)"))
            ])
        ]
        
        if includeDark {
            sources.append(
                .element(named: "source", nodes: [
                    .attribute(named: "srcset", value: imagePath.srcset(suffix: "-dark")),
                    .attribute(named: "media", value: "(prefers-color-scheme: dark)")
                ])
            )
        }
        
        return .group(sources)
    }
}

// MARK: - Internal Extensions

extension Node where Context : HTMLImageContainerContext {
    /// Returns an img element for the given retinaImage
    static func img(_ retinaImage: RetinaImagePath, alt: String? = nil, imgAttributes: [Attribute<HTML.ImageContext>]) -> Node {
        var imgAttributes = imgAttributes
        imgAttributes.append(.src(retinaImage.retinaURL(scale: 1).path))
        if let alt = alt {
            imgAttributes.append(.alt(alt))
        }

        return .selfClosedElement(named: "img", attributes: imgAttributes)
    }
}

extension Node where Context: HTML.BodyContext {
    static func picture(retinaImage: RetinaImagePath, includeDark: Bool = false, alt: String? = nil, imgAttributes: [Attribute<HTML.ImageContext>]) -> Node {
        .picture(
            .sources(retinaImage, includeDark: includeDark),
            .img(retinaImage, alt: alt, imgAttributes: imgAttributes)
        )
    }
}

extension RetinaImagePath {
    func srcset(suffix: String = "") -> String {
        var sources = [String]()
        
        for scale in 1...self.originalScale {
            let source = "\(self.retinaURL(scale: scale, suffix: suffix).path) \(scale)x"
            sources.append(source)
        }
        
        return sources.joined(separator: ",")
    }
}
