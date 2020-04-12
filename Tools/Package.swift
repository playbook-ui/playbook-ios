// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/ra1028/swift-mod.git", .exact("0.0.3")),
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.2-branch")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .exact("2.15.1")),
    ],
    targets: [.target(name: "Tools", path: "TargetStub")]
)
