// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "DynamicList",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
    ],
    products: [
        .library(name: "DynamicList", targets: ["DynamicList"]),
    ],
    targets: [
        .target(name: "DynamicList"),
        .testTarget(name: "DynamicListTests", dependencies: ["DynamicList"]),
    ]
)
