//
//  Node+retinaPictureMarkdown.swift
//
//
//  Created by David Monagle on 14/8/21.
//

import Plot
import RetinaPicture


public extension Node where Context: HTML.BodyContext {
    static func retinaPicture(markdown: String, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        guard let imageMeta = MarkdownImageMeta(markdown: markdown) else {
            return .empty
        }

        return .retinaPicture(
            path: imageMeta.url.path,
            includeDark: imageMeta.queryKeyExists("dark"),
            imgAttributes: imgAttributes
        )
    }
    
    static func retinaPicture(markdown: Substring, _ imgAttributes: Attribute<HTML.ImageContext>...) -> Node {
        retinaPicture(markdown: String(markdown))
    }
}


