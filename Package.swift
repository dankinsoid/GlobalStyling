// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GlobalStyling",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "GlobalStyling", targets: ["GlobalStyling"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "GlobalStyling",
            dependencies: [
            ]
        )
    ]
)
