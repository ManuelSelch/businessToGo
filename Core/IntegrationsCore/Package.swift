// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "IntegrationsCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "IntegrationsCore",
            targets: ["IntegrationsCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.3")),
        .package(url: "https://github.com/ManuelSelch/Dependencies.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        .target(
            name: "IntegrationsCore",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync"),
                .product(name: "Dependencies", package: "Dependencies")
            ]
        ),
        .testTarget(
            name: "IntegrationsCoreTests",
            dependencies: ["IntegrationsCore"]
        ),
    ]
)
