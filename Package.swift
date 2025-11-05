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
    )
  ],
  dependencies: [
    // https://github.com/RapboyGao/SwiftRelativeTime.git
    .package(url: "https://github.com/RapboyGao/SwiftRelativeTime.git", from: "1.0.0"),
    // https://github.com/RapboyGao/SwiftI18n.git
    .package(url: "https://github.com/RapboyGao/SwiftI18n.git", from: "1.0.0"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "AChecklist",
      dependencies: [
        .product(name: "SwiftRelativeTime", package: "SwiftRelativeTime"),
        .product(name: "SwiftI18n", package: "SwiftI18n"),
      ],
      resources: [
        .process("Resources")
      ]
    ),
    .testTarget(
      name: "AChecklistTests",
      dependencies: ["AChecklist"]
    ),
  ]
)
