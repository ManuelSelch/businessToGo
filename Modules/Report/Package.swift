// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Report",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "Report",
            targets: ["Report"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.7")),
        .package(url: "https://github.com/manuelselch/Dependencies", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/manuelselch/Chart", .upToNextMajor(from: "1.0.3")),
        
        .package(path: "../../Core/KimaiCore"),
    ],
    targets: [
        .target(
            name: "Report",
            dependencies: [
                .product(name: "KimaiCore", package: "KimaiCore"),
                .product(name: "Redux", package: "Redux"),
                .product(name: "Dependencies", package: "Dependencies"),
                .product(name: "MyChart", package: "Chart")
            ]
        ),
        .testTarget(
            name: "ReportTests",
            dependencies: ["Report"]),
    ]
)
