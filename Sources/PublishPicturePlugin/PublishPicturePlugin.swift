//
//  PublishPicturePlugin.swift
//
//  Created by David Monagle
//  Copyright © 2020 David Monagle. All rights reserved.
//

import Publish
import Ink
import Plot

public extension Plugin {
    static var useRetinaPictures: Self {
        return Plugin(name: "Use retina pictures if available") { context in
            context.markdownParser.addModifier(.pictureImageModifier)
        }
    }
}

extension Modifier {
    static var pictureImageModifier: Self {
        Modifier(target: .images) { html, markdown in
            guard
                let imageMeta = MarkdownImageMeta(markdown: markdown),
                let node = try? Node.retinaPicture(path: imageMeta.url.path, includeDark: imageMeta.queryKeyExists("dark"))
            else {
                return html
            }
            
            return node.render()
        }
    }
}
