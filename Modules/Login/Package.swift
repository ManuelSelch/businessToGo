// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v16),
        .macOS(.v14)
    ],
    products: [
        .library(name: "LoginCore",targets: ["LoginCore"]),
        .library(name: "LoginServices", targets: ["LoginServices"]),
        .library(name: "LoginUI", targets: ["LoginUI"]),
        
        .library(name: "LoginApp", targets: ["LoginApp"])
    ],
    dependencies: [
        .package(url: "https://github.com/manuelselch/Redux.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/manuelselch/Dependencies.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/ManuelSelch/LoginService.git", .upToNextMajor(from: "1.1.3")),
        
        .package(path: "../Kimai"),
        
        .package(path: "../../Common")
    ],
    targets: [
        .target(
            name: "LoginCore",
            dependencies: [
                .product(name: "LoginService", package: "LoginService") // todo: LoginServiceCore
            ],
            path: "Sources/Core"
        ),
        
        .target(
            name: "LoginUI",
            dependencies: [
                "LoginCore",
                .product(name: "CommonUI", package: "Common")
            ],
            path: "Sources/UI"
        ),
        
        .target(
            name: "LoginServices",
            dependencies: [
                "LoginCore",
                .product(name: "LoginService", package: "LoginService"),
                .product(name: "Dependencies", package: "Dependencies")
            ],
            path: "Sources/Services"
        ),
        
        .target(
            name: "LoginApp",
            dependencies: [
                "LoginCore", "LoginServices", "LoginUI",
                .product(name: "Dependencies", package: "Dependencies"),
                .product(name: "LoginService", package: "LoginService"),
                .product(name: "Redux", package: "Redux"),
                
                .product(name: "KimaiServices", package: "Kimai")
            ],
            path: "Sources/App"
        ),
        
        
        .testTarget(name: "CoreTests",dependencies: ["LoginCore"]),
        .testTarget(name: "UITests", dependencies: ["LoginUI"]),
    ]
)
