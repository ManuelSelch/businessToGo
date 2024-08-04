// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "Integration",
    platforms: [ .iOS(.v16) ],
    products: [
        .library(name: "IntegrationApp", targets: ["IntegrationApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ManuelSelch/Redux", .upToNextMajor(from: "1.2.12"))
    ],
    targets: [
        .target(
            name: "IntegrationApp",
            dependencies: [
                "IntegrationCore",
                .product(name: "Redux", package: "Redux")
            ],
            path: "Sources/App"
        ),
        
            .target(
                name: "IntegrationCore",
                dependencies: [
                ],
                path: "Sources/Core"
            ),
            
        
    ]
)
