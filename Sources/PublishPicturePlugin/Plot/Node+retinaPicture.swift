//
//  Node+retinaPicture.swift
//  
//
//  Created by David Monagle on 16/6/20.
//

import Publish
import Plot
import Foundation

extension Node where Context: HTML.BodyContext {
    static func retinaPicture(path: String, includeDark: Bool = false, alt: String? = nil, imgAttributes: [Attribute<HTML.ImageContext>]) -> Node {
        let retinaImage = RetinaImagePath(stringLiteral: path)
        
        var sourceNodes: [Node<HTML.BodyContext>] = [
            .element(named: "source", nodes: [
                .attribute(named: "srcset", value: retinaImage.srcset()),
                .if(includeDark, .attribute(named: "media", value: "(prefers-color-scheme: light)"))
            ])
        ]
        
        if includeDark {
            sourceNodes.append(
                .element(named: "source", nodes: [
                    .attribute(named: "srcset", value: retinaImage.srcset(postfix: "-dark")),
                    .attribute(named: "media", value: "(prefers-color-scheme: dark)")
                ])
            )
        }
        
        var imgAttributes = imgAttributes
        imgAttributes.append(.src(retinaImage.retinaURL(scale: 1).path))
        if let alt = alt {
            imgAttributes.append(.alt(alt))
        }
        
        return .element(named: "picture", nodes: [
            .group(sourceNodes),
            .selfClosedElement(named: "img", attributes: imgAttributes)
        ])
    }
    
    static func retinaPicture(markdown: String, imgAttributes: [Attribute<HTML.ImageContext>]) -> Node {
        guard let imageMeta = MarkdownImageMeta(markdown: markdown) else {
            return .empty
        }

        return .retinaPicture(
            path: imageMeta.url.path,
            includeDark: imageMeta.queryKeyExists("dark"),
            imgAttributes: imgAttributes
        )
    }

}

public extension Node where Context: HTML.BodyContext {
    static func retinaPicture(path: String, includeDark: Bool = false, alt: String? = nil, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        .retinaPicture(
            path: path,
            includeDark: includeDark,
            alt: alt,
            imgAttributes: imgAttributes
        )
    }
    
    static func retinaPicture(markdown: Substring, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        retinaPicture(markdown: String(markdown), imgAttributes: imgAttributes)
    }
}

extension RetinaImagePath {
    func srcset(postfix: String = "") -> String {
        var sources = [String]()
        
        for scale in 1...self.originalScale {
            let source = "\(self.retinaURL(scale: scale, postfix: postfix).path) \(scale)x"
            sources.append(source)
        }
        
        return sources.joined(separator: ",")
    }
}

extension Node where Context == HTML.BodyContext {
    static func img(src: String, alt: String? = nil, _ attributes: [Attribute<HTML.ImageContext>] = []) -> Node {
        var attributes = attributes
        attributes.append(.src(src))
        if let alt = alt {
            attributes.append(.alt(alt))
        }
        return .selfClosedElement(named: "img", attributes: attributes)
    }
}
