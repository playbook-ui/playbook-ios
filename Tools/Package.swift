// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "dev-tools",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", exact: "509.0.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", exact: "2.40.1"),
    ]
)
