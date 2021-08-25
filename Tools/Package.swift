// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/apple/swift-format.git", .branch("0.50400.0")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .exact("2.24.0")),
    ]
)
