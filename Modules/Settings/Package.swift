// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Settings",
            targets: ["Settings"]),
    ],
    dependencies: [
        .package(path: "../../Core/KimaiCore"),
        .package(path: "../../Core/TaigaCore"),
        .package(path: "../../Core/IntegrationsCore"),
        .package(path: "../Login"),
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "4.2.3"))
    ],
    targets: [
        .target(
            name: "Settings",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "KimaiCore", package: "KimaiCore"),
                .product(name: "TaigaCore", package: "TaigaCore"),
                .product(name: "IntegrationsCore", package: "IntegrationsCore"),
                .product(name: "Login", package: "Login"),
                .product(name: "PulseUI", package: "Pulse")
            ]
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["Settings"]),
    ]
)
