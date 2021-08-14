//
//  RetinaImageConversion.swift
//
//  Created by David Monagle
//  Copyright © 2020 David Monagle. All rights reserved.
//

import RetinaPicture
import Publish
import Foundation
import ShellOut

/// Converts a retina image to another scale
public struct RetinaImageConversion<Site> where Site : Website {
    public typealias Closure = (RetinaImagePath, Int, PublishingContext<Site>) throws -> ()
    var convert: Closure
}

// MARK: - sips

public extension RetinaImageConversion {
    /// Uses the sips command line tool to create scaled images
    static var sips: Self {
        return .init(
            convert: { originalImage, scale, context in
                guard originalImage.originalScale != scale else { return }
                
                let path = originalImage.originalURL.path
                let newImage = originalImage.retinaURL(scale: scale)
                
                let result = try shellOut(to: "sips -g pixelWidth \"\(path)\"")
                let split = result.split(separator: " ")

                if let widthString = split.last, let width = Int(widthString) {
                    let ratio = Double(scale)/Double(originalImage.originalScale)
                    let newWidth = Int(Double(width)*ratio)
                    try FileManager.default.copyItem(at: originalImage.originalURL, to: newImage)
                    try shellOut(to: "sips --resampleWidth \(newWidth) \"\(newImage.path)\"")
                }
            }
        )
    }
}
