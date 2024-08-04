// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Debug",
    platforms: [ .iOS(.v16) ],
    products: [
        .library(name: "DebugApp", targets: ["DebugApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ManuelSelch/Redux", .upToNextMajor(from: "1.2.12"))
    ],
    targets: [
        .target(
            name: "DebugApp",
            dependencies: [
                .product(name: "Redux", package: "Redux")
            ],
            path: "Sources/App"
        ),
        
        
        
    ]
)
