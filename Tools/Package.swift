// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Tools",
    dependencies: [
        .package(url: "https://github.com/ra1028/swift-mod.git", .exact("0.0.4")),
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.3-branch")),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", .exact("2.18.0")),
        .package(url: "https://github.com/SwiftDocOrg/swift-doc.git", .revision("164157531625a77474884185d1cba0c12ebe0cfa")),
    ],
    targets: [.target(name: "Tools", path: "TargetStub")]
)
