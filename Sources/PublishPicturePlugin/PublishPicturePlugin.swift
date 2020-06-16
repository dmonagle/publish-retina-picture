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
            Node.retinaPicture(markdown: markdown).render()
        }
    }
}
