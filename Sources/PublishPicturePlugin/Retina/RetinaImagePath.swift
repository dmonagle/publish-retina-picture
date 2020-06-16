//
//  RetinaImagePath.swift
//
//  Created by David Monagle
//  Copyright © 2020 David Monagle. All rights reserved.
//

import Foundation

/// Breaks down a path that contains a retina image
public struct RetinaImagePath: ExpressibleByStringLiteral {
    public let originalURL: URL
    public let basePath: String
    public let fileExtension: String
    public let originalScale: Int

    public init(stringLiteral path: String) {
        self.originalURL = URL(fileURLWithPath: path)
        self.fileExtension = originalURL.pathExtension
        let basePath = originalURL.deletingPathExtension().absoluteString.removingPercentEncoding ?? ""
        
        let split = basePath.split(separator: "@")
        if
            split.count == 2,
            let scaleCharacter = split[1].first,
            let scale = Int(String(scaleCharacter))
        {
            self.basePath = String(split[0])
            originalScale = scale
        }
        else {
            self.basePath = basePath
            originalScale = 1
        }
    }
    
    func retinaURL(scale: Int = 1) -> URL {
        var basePath = self.basePath
        if scale > 1 {
            basePath = "\(basePath)@\(scale)x"
        }

        var url = URL(fileURLWithPath: basePath)
        url = url.appendingPathExtension(self.fileExtension)
        return url
    }
}
