// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/ra1028/swift-mod.git", .exact("0.0.2")),
        .package(url: "https://github.com/ra1028/swift-format.git", .branch("swift-5.1-branch-latest")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .exact("2.13.1")),
    ]
)
