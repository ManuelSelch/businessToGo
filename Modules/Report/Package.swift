// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Report",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Report",
            targets: ["Report"]),
    ],
    dependencies: [
        .package(path: "../Management"),
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Report",
            dependencies: [
                .product(name: "ManagementDependencies", package: "Management"),
                .product(name: "Management", package: "Management"),
                .product(name: "Redux", package: "Redux")
            ]
        ),
        .testTarget(
            name: "ReportTests",
            dependencies: ["Report"]),
    ]
)
