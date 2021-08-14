//
//  PublishingStep.swift
//  
//
//  Created by David Monagle on 16/6/20.
//

import RetinaPicture
import Publish
import Files
import Foundation

public extension PublishingStep {
    /// Creates correctly scaled versions of all retina images in the output path
    static func generateRetinaImages(in relativePath: Path = "", conversion: RetinaImageConversion<Site>) throws -> Self {
        .step(named: "Generate retina scaled images") { context in
            let folder = try context.outputFolder(at: relativePath)
            try generateRetinaImages(in: folder, conversion: conversion, context: context)
        }
    }
    
    private static func generateRetinaImages(in folder: Folder, conversion: RetinaImageConversion<Site>, context: PublishingContext<Site>) throws {
        for subfolder in folder.subfolders {
            try generateRetinaImages(in: subfolder, conversion: conversion, context: context)
        }

        for file in folder.files {
            guard file.isImage else { continue }

            let retinaImage = RetinaImagePath(stringLiteral: file.path)
            
            if retinaImage.originalScale > 1 {
                let scales = 1...retinaImage.originalScale
                for scale in scales.reversed() {
                    let retinaURL = retinaImage.retinaURL(scale: scale)
                    if !FileManager.default.fileExists(atPath: retinaURL.path) {
                        try conversion.convert(retinaImage, scale, context)
                    }
                }
            }
        }
    }
}

fileprivate extension File {
    private static let imageFileExtensions: Set<String> = [
        "jpg", "jpeg", "png", "gif", "webp"
    ]

    var isImage: Bool {
        self.extension.map(File.imageFileExtensions.contains) ?? false
    }
}
