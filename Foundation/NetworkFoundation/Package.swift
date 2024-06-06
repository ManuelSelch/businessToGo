// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NetworkFoundation",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "NetworkFoundation",
            targets: ["NetworkFoundation"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "15.0.3"))
    ],
    targets: [
        .target(
            name: "NetworkFoundation",
            dependencies: [
                .product(name: "Moya", package: "Moya")
            ]
        ),
        .testTarget(
            name: "NetworkFoundationTests",
            dependencies: ["NetworkFoundation"]
        ),
    ]
)
