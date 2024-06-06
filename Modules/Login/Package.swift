// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux.git", .upToNextMajor(from: "1.1.7")),
        .package(url: "https://github.com/manuelselch/Dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ManuelSelch/LoginService.git", .upToNextMajor(from: "1.1.3")),
        
        .package(path: "../../Core/KimaiCore"),
        .package(path: "../../Core/TaigaCore"),
        .package(path: "../../AppCore")
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies"),
                .product(name: "LoginService", package: "LoginService"),
                
                .product(name: "KimaiCore", package: "KimaiCore"),
                .product(name: "TaigaCore", package: "TaigaCore"),
                .product(name: "AppCore", package: "AppCore")
            ]
        ),
        .testTarget(
            name: "LoginTests",
            dependencies: ["Login"]
        ),
    ]
)
