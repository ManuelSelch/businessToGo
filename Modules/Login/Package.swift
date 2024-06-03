// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Login",
            targets: ["Login"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux.git", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/ManuelSelch/LoginService.git", .upToNextMajor(from: "1.1.3")),
        
        .package(path: "../Management"),
        .package(path: "../../Shared")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Login",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "LoginService", package: "LoginService"),
                
                .product(name: "ManagementDependencies", package: "Management"),
                .product(name: "Shared", package: "Shared")
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        ),
    ]
)
