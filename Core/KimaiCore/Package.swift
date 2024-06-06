// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KimaiCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "KimaiCore",
            targets: ["KimaiCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.3")),
        .package(url: "https://github.com/ManuelSelch/Dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(path: "../../Foundation/NetworkFoundation")
    ],
    targets: [
        .target(
            name: "KimaiCore",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync"),
                .product(name: "Dependencies", package: "Dependencies"),
                .product(name: "NetworkFoundation", package: "NetworkFoundation")
            ]
        ),
        .testTarget(
            name: "KimaiCoreTests",
            dependencies: ["KimaiCore"]
        ),
    ]
)
