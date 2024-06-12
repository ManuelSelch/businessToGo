// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Management",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "ManagementApp", targets: ["ManagementApp"]),
        .library(name: "ManagementCore", targets: ["ManagementCore"]),
        .library(name: "ManagementServices", targets: ["ManagementServices"])
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.9")),
        .package(url: "https://github.com/ManuelSelch/OfflineSync.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/ManuelSelch/Chart.git", .upToNextMajor(from: "1.0.3")),
        
        .package(path: "../../Common"),
        
        .package(path: "../Kimai"),
        .package(path: "../Taiga"),
    ],
    targets: [
        .target(
            name: "ManagementCore",
            dependencies: [
                .product(name: "OfflineSync", package: "OfflineSync"),
                .product(name: "KimaiCore", package: "Kimai"),
                .product(name: "TaigaCore", package: "Taiga")
            ],
            path: "Sources/Core"
        ),
        
        .target(
            name: "ManagementServices", 
            dependencies: ["ManagementCore"],
            path: "Sources/Services"
        ),
        
        .target(
            name: "ManagementUI",
            dependencies: [
                "ManagementCore",
                .product(name: "CommonUI", package: "Common")
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "ManagementApp",
            dependencies: [
                "ManagementCore", "ManagementServices", "ManagementUI",
                .product(name: "Redux", package: "Redux"),
                .product(name: "MyChart", package: "Chart"),
                .product(name: "OfflineSync", package: "OfflineSync"),
            
                .product(name: "KimaiApp", package: "Kimai"),
                .product(name: "TaigaApp", package: "Taiga"),
                
            ],
            path: "Sources/App"
        ),
            
        
        .testTarget(
            name: "ManagementTests",
            dependencies: [
                "ManagementApp",
                .product(name: "ReduxTestStore", package: "Redux")
            ]
        )
    ]
)
