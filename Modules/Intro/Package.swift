// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Intro",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Intro",
            targets: ["Intro"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(path: "../../Shared")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Intro",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "Shared", package: "Shared")
            ]
        ),
        .testTarget(
            name: "IntroTests",
            dependencies: ["Intro"]),
    ]
)
