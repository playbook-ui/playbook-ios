// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "dev-tools",
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-format.git", exact: "510.1.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", exact: "2.42.0"),
    ]
)
