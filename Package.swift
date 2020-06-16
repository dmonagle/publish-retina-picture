// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PublishPicturePlugin",
    products: [
        .library(
            name: "PublishPicturePlugin",
            targets: ["PublishPicturePlugin"]),
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "PublishPicturePlugin",
            dependencies: ["Publish"]),
        .testTarget(
            name: "PublishPicturePluginTests",
            dependencies: ["PublishPicturePlugin"]),
    ]
)
