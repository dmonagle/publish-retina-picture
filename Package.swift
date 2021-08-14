// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "publish-retina-picture",
    products: [
        .library(
            name: "RetinaPicture",
            targets: [
                "RetinaPicture"
            ]
        ),
        .library(
            name: "RetinaPictureConversion",
            targets: [
                "RetinaPictureConversion"
            ]
        ),
        .library(
            name: "RetinaInk",
            targets: [
                "RetinaInk"
            ]
        ),
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
        .package(name: "ShellOut", url: "https://github.com/johnsundell/ShellOut.git", from: "2.3.0"),
        .package(name: "Plot", url: "https://github.com/johnsundell/plot.git", from: "0.10.0"),
    ],
    targets: [
        .target(
            name: "RetinaPicture",
            dependencies: ["Plot"]
        ),
        .target(
            name: "RetinaPictureConversion",
            dependencies: ["RetinaPicture", "Publish", "ShellOut"]
        ),
        .target(
            name: "RetinaInk",
            dependencies: ["RetinaPicture", "Publish"]
        ),
        .testTarget(
            name: "RetinaPictureTests",
            dependencies: ["RetinaPicture"]
        ),
        .testTarget(
            name: "RetinaInkTests",
            dependencies: ["RetinaInk"]
        ),
    ]
)
