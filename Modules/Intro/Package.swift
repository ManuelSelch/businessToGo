// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Intro",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Intro", targets: ["Intro"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "Intro",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "CommonServices", package: "Common")
            ]
        ),
        .testTarget(
            name: "IntroTests",
            dependencies: ["Intro"]),
    ]
)
