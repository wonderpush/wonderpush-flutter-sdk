// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "wonderpush_flutter",
    platforms: [
        .iOS("15.0"),
    ],
    products: [
        .library(name: "wonderpush-flutter", targets: ["wonderpush_flutter"]),
    ],
    dependencies: [
        .package(url: "https://github.com/wonderpush/wonderpush-ios-sdk", exact: "4.5.0"),
    ],
    targets: [
        .target(
            name: "wonderpush_flutter",
            dependencies: [
                .product(name: "WonderPush", package: "wonderpush-ios-sdk"),
            ],
            resources: [
                // If your plugin requires a privacy manifest, add it here.
            ]
        ),
    ]
)
