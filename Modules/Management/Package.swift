// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Management",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Management",
            targets: ["Management"]
        ),
        
        .library(
            name: "ManagementDependencies",
            targets: ["ManagementDependencies"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/ManuelSelch/Chart.git", .upToNextMajor(from: "1.0.3")),
        
        .package(path: "../../Shared")
    ],
    targets: [
        .target(
            name: "Management",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "MyChart", package: "Chart"),
                .product(name: "OfflineSync", package: "OfflineSync"),
            
                .product(name: "Shared", package: "Shared"),
                "ManagementDependencies"
            ]
        ),
        
        .target(
            name: "ManagementDependencies",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync"),
            ]
        ),
            
        
        .testTarget(
            name: "ManagementTests",
            dependencies: ["Management"]
        )
    ]
)
