// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DealMind",
    platforms: [
        .iOS(.v14)
    ],
    dependencies: [
        // SnapKit - 约束布局库
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0")
    ],
    targets: [
        .target(
            name: "DealMind",
            dependencies: [
                "SnapKit"
            ]
        )
    ]
) 