// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "LoginCore",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "LoginCore",
            targets: ["LoginCore"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ManuelSelch/LoginService.git", .upToNextMajor(from: "1.1.3"))
    ],
    targets: [
        .target(
            name: "LoginCore",
            dependencies: [
                .product(name: "Dependencies", package: "Dependencies"),
                .product(name: "LoginService", package: "LoginService")
            ]
        ),
        .testTarget(
            name: "LoginCoreTests",
            dependencies: ["LoginCore"]
        ),
    ]
)
