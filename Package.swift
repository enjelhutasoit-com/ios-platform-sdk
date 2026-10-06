// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ios-platform-sdk",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "ios-platform-sdk",
            targets: ["ios-platform-sdk"]),
    ],
    targets: [
        .target(
            name: "ios-platform-sdk"),
        .testTarget(
            name: "ios-platform-sdkTests",
            dependencies: ["ios-platform-sdk"]
        ),
    ]
)
