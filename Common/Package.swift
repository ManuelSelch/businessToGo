// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CommonCore", targets: ["CommonCore"]),
        .library(name: "CommonUI", targets: ["CommonUI"]),
        .library(name: "CommonServices", targets: ["CommonServices"]),
    ],
    dependencies: [
       
    ],
    targets: [
        .target(name: "CommonCore", path: "Sources/Core"),
        .target(name: "CommonUI", path: "Sources/UI"),
        .target(name: "CommonServices", path: "Sources/Services"),
        
        .testTarget(name: "CommonCoreTests",dependencies: ["CommonCore"], path: "Tests/CoreTests"),
    ]
)
