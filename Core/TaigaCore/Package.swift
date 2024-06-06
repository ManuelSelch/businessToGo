// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "TaigaCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "TaigaCore",
            targets: ["TaigaCore"]),
    ],
    dependencies: [
        .package(path: "../../AppCore"),
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.3")),
        .package(url: "https://github.com/ManuelSelch/Dependencies.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "TaigaCore",
            dependencies: [
                .product(name: "AppCore", package: "AppCore"),
                .product(name: "OfflineSync", package: "OfflineSync"),
                .product(name: "Dependencies", package: "Dependencies")
            ]
        ),
        .testTarget(
            name: "TaigaCoreTests",
            dependencies: ["TaigaCore"]),
    ]
)
