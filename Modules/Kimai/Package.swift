// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Kimai",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(name: "KimaiCore", targets: ["KimaiCore"]),
        .library(name: "KimaiUI", targets: ["KimaiUI"]),
        .library(name: "KimaiServices", targets: ["KimaiServices"]),
        .library(name: "KimaiApp", targets: ["KimaiApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/OfflineSync", .upToNextMajor(from: "1.3.3")),
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.2.14")),
        .package(url: "https://github.com/manuelselch/Dependencies", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ManuelSelch/Chart", .upToNextMajor(from: "1.0.4")),
        
        .package(path: "../../Foundation/NetworkFoundation"),
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "KimaiCore",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync")
            ],
            path: "Sources/Core"
        ),
        
        .target(
            name: "KimaiUI",
            dependencies: [
                "KimaiCore",
                .product(name: "MyChart", package: "Chart"),
                .product(name: "CommonUI", package: "Common"),
                .product(name: "CommonCore", package: "Common")
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "KimaiServices",
            dependencies: [
                "KimaiCore",
                .product(name: "NetworkFoundation", package: "NetworkFoundation")
            ],
            path: "Sources/Services"
        ),
        
        .target(
            name: "KimaiApp",
            dependencies: [
                "KimaiCore", "KimaiUI", "KimaiServices",
                .product(name: "Redux", package: "Redux"),
                .product(name: "ReduxDebug", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies")
            ],
            path: "Sources/App"
        ),
        
        .testTarget(
            name: "KimaiCoreTests",
            dependencies: [
                "KimaiCore",
                "KimaiApp",
                .product(name: "ReduxTestStore", package: "Redux")
            ],
            path: "Tests/CoreTests"
        ),
    ]
)
