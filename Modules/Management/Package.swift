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
        )
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/ManuelSelch/Chart.git", .upToNextMajor(from: "1.0.3")),
        
        .package(path: "../../AppCore"),
        .package(path: "../../Core/KimaiCore"),
        .package(path: "../../Core/TaigaCore")
    ],
    targets: [
        .target(
            name: "Management",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "MyChart", package: "Chart"),
                .product(name: "OfflineSync", package: "OfflineSync"),
            
                .product(name: "AppCore", package: "AppCore"),
                .product(name: "KimaiCore", package: "KimaiCore"),
                .product(name: "TaigaCore", package: "TaigaCore")
                
            ]
        ),
            
        
        .testTarget(
            name: "ManagementTests",
            dependencies: ["Management"]
        )
    ]
)
