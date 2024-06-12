// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Taiga",
    platforms: [.iOS(.v16), .macOS(.v14)],
    products: [
        .library(name: "TaigaCore", targets: ["TaigaCore"]),
        .library(name: "TaigaServices", targets: ["TaigaServices"]),
        .library(name: "TaigaUI", targets: ["TaigaUI"]),
        .library(name: "TaigaApp", targets: ["TaigaApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/OfflineSync", .upToNextMajor(from: "1.2.4")),
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.2.0")),
        .package(url: "https://github.com/manuelselch/Dependencies", .upToNextMajor(from: "1.0.0")),
        
        .package(path: "../../Foundation/NetworkFoundation"),
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "TaigaCore",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync")
            ],
            path: "Sources/Core"
        ),
        
        .target(
            name: "TaigaServices",
            dependencies: [
                "TaigaCore",
                .product(name: "NetworkFoundation", package: "NetworkFoundation"),
                .product(name: "CommonCore", package: "Common")
            ],
            path: "Sources/Services"
        ),
        
        .target(
            name: "TaigaUI",
            dependencies: [
                "TaigaCore",
                .product(name: "CommonUI", package: "Common")
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "TaigaApp",
            dependencies: [
                "TaigaCore", "TaigaServices", "TaigaUI",
                .product(name: "Redux", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies")
            ],
            path: "Sources/App"
        ),
        
        .testTarget(
            name: "TaigaAppTests",
            dependencies: ["TaigaApp"],
            path: "Tests/AppTests"
        ),
    ]
)
