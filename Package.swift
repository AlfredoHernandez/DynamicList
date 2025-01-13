// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "DynamicList",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
    ],
    products: [
        .library(name: "DynamicList", targets: ["DynamicList"]),
    ],
    dependencies: [
        .package(url: "https://github.com/elai950/AlertToast.git", from: "1.3.7"),
    ],
    targets: [
        .target(name: "DynamicList", dependencies: [
            .product(name: "AlertToast", package: "AlertToast"),
        ]),
        .testTarget(name: "DynamicListTests", dependencies: ["DynamicList"]),
    ]
)
