//
//  RetinaPicture.swift
//  RetinaPicture
//
//  Created by David Monagle on 14/8/21.
//

import Plot

public struct RetinaPicture: Component {
    public typealias ImageModifier = (Component) -> Component
    private typealias ImageNode = Node<HTML.PictureContext>
    
    private let path: RetinaImagePath
    private let includeDark: Bool
    private let description: String?
    private let imageModifier: ImageModifier?

    public init(url: String, includeDark: Bool = false, description: String? = nil, @ComponentBuilder image: @escaping ImageModifier) {
        self.path = RetinaImagePath(stringLiteral: url)
        self.includeDark = includeDark
        self.description = description
        self.imageModifier = image
    }

    public init(url: String, includeDark: Bool = false, description: String? = nil) {
        self.path = RetinaImagePath(stringLiteral: url)
        self.includeDark = includeDark
        self.description = description
        self.imageModifier = nil
    }

    public init(_ retinaImage: RetinaImagePath, includeDark: Bool = false, description: String? = nil, @ComponentBuilder image: @escaping ImageModifier) {
        self.path = retinaImage
        self.includeDark = includeDark
        self.description = description
        self.imageModifier = image
    }

    public init(_ retinaImage: RetinaImagePath, includeDark: Bool = false, description: String? = nil) {
        self.path = retinaImage
        self.includeDark = includeDark
        self.description = description
        self.imageModifier = nil
    }

    public var body: Component {
        Node.picture(
            .sources(path, includeDark: includeDark),
            image
        )
    }
    
    private var image: ImageNode {
        let baseImage = Image(url: path.retinaURL(scale: 1).path, description: description ?? "...")
        
        if let imageModifier = imageModifier {
            return imageModifier(baseImage).convertToNode()
        }
        else {
            return baseImage.convertToNode()
        }
    }
}
