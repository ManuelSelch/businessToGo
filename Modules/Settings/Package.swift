// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Settings",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SettingsUI", targets: ["SettingsUI"]),
        .library(name: "SettingsApp", targets: ["SettingsApp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux", .upToNextMajor(from: "1.1.5")),
        .package(url: "https://github.com/kean/Pulse.git", .upToNextMajor(from: "4.2.3")),
       
        .package(path: "../../Common"),
        
        .package(path: "../Kimai"),
        .package(path: "../Taiga"),
        .package(path: "../Management"),
        .package(path: "../Login"),
    ],
    targets: [
        .target(
            name: "SettingsApp",
            dependencies: [
                "SettingsUI",
                .product(name: "Redux", package: "Redux"),
                
                .product(name: "KimaiCore", package: "Kimai"),
                .product(name: "KimaiServices", package: "Kimai"),
                
                .product(name: "TaigaCore", package: "Taiga"),
                .product(name: "TaigaServices", package: "Taiga"),
                
                .product(name: "ManagementCore", package: "Management"),
                .product(name: "ManagementServices", package: "Management"),
                
                .product(name: "LoginCore", package: "Login"),
                .product(name: "LoginServices", package: "Login"),
                
                .product(name: "CommonServices", package: "Common")
                
            ],
            path: "Sources/App"
        ),
        
        .target(
            name: "SettingsUI",
            dependencies: [
                .product(name: "PulseUI", package: "Pulse"),
                .product(name: "CommonUI", package: "Common"),
                
                .product(name: "KimaiCore", package: "Kimai"),
                .product(name: "TaigaCore", package: "Taiga"),
                .product(name: "ManagementCore", package: "Management"),
                .product(name: "LoginCore", package: "Login")
            ],
            path: "Sources/UI"
        ),
        .testTarget(
            name: "SettingsTests",
            dependencies: ["SettingsApp"]),
    ]
)
