// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IOSPlatformSDK",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "IOSPlatformSDK",
            targets: ["IOSPlatformSDK"]),
    ],
    targets: [
        .target(
            name: "IOSPlatformSDK"),
        .testTarget(
            name: "IOSPlatformSDKTests",
            dependencies: ["IOSPlatformSDK"]
        ),
    ]
)
