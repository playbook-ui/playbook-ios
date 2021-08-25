// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Doc",
    dependencies: [
        .package(url: "https://github.com/SwiftDocOrg/swift-doc.git", .branch("1.0.0-rc.1")),
    ]
)
