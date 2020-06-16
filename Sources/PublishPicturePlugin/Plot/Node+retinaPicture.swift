//
//  Node+retinaPicture.swift
//  
//
//  Created by David Monagle on 16/6/20.
//

import Publish
import Plot
import Foundation

public extension Node where Context: HTML.BodyContext {
    static func retinaPicture(path: String, includeDark: Bool, _ nodes: Node<HTML.BodyContext>...) throws -> Node {
        let retinaImage = RetinaImagePath(stringLiteral: path)
        
        var sourceNodes: [Node<HTML.BodyContext>] = [
            .element(named: "source", nodes: [
                .attribute(named: "srcset", value: retinaImage.srcset)
            ])
        ]
        
        if includeDark {
            let darkPath = "\(path)-dark"
            let darkRetinaImage = RetinaImagePath(stringLiteral: darkPath)

            sourceNodes.append(
                .element(named: "source", nodes: [
                    .attribute(named: "media", value: "(prefers-color-scheme: dark)"),
                    .attribute(named: "srcset", value: darkRetinaImage.srcset)
                ])
            )
        }
        
        return .element(named: "picture", nodes: [
            .group(sourceNodes),
            .img(
                .src(retinaImage.retinaURL(scale: 1).path)
            ),
            .group(nodes)
        ])
    }
}

extension RetinaImagePath {
    var srcset: String {
        var sources = [String]()
        
        for scale in 1...self.originalScale {
            let source = "\(self.retinaURL(scale: scale).path) \(scale)x"
            sources.append(source)
        }
        
        return sources.joined(separator: ",")
    }
}
