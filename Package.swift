// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AChecklist",
    defaultLocalization: "en",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AChecklist",
            targets: ["AChecklist"]
        ),
    ],
    // https://github.com/RapboyGao/SwiftRelativeTime.git
    dependencies: [
        .package(url: "https://github.com/RapboyGao/SwiftRelativeTime.git", from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AChecklist",
            dependencies: [
                .product(name: "SwiftRelativeTime", package: "SwiftRelativeTime"),
            ]
        ),
        .testTarget(
            name: "AChecklistTests",
            dependencies: ["AChecklist"]
        ),
    ]
)
