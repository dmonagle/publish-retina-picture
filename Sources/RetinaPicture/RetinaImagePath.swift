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
    
    /// Returns a URL of the image at the appropriate scale
    public func retinaURL(scale: Int = 1, suffix: String = "") -> URL {
        let basePath: String
        if scale > 1 {
            basePath = "\(self.basePath)\(suffix)@\(scale)x"
        }
        else {
            basePath = "\(self.basePath)\(suffix)"
        }

        var url = URL(fileURLWithPath: basePath)
        url = url.appendingPathExtension(self.fileExtension)
        return url
    }
}
