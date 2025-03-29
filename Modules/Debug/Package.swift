// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Debug",
    platforms: [ .iOS(.v16), .macOS(.v14) ],
    products: [
        .library(name: "DebugApp", targets: ["DebugApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ManuelSelch/Redux", .upToNextMajor(from: "1.2.12")),
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "DebugApp",
            dependencies: [
                .product(name: "Redux", package: "Redux"),
                .product(name: "CommonServices", package: "Common")
            ],
            path: "Sources/App"
        ),
        
        
        
    ]
)
