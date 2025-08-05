// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BluetoothKit",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "BluetoothKit",
            targets: ["BluetoothKit"])
    ],
    targets: [
        .target(
            name: "BluetoothKit",
            dependencies: []),
        .testTarget(
            name: "BluetoothKitTests",
            dependencies: ["BluetoothKit"])
    ]
)
