// swift-tools-version:5.9

import Foundation
import PackageDescription

let package = Package(
    name: "Playbook",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(name: "Playbook", targets: ["Playbook"]),
        .library(name: "PlaybookSnapshot", targets: ["PlaybookSnapshot"]),
        .library(name: "PlaybookUI", targets: ["PlaybookUI"]),
    ],
    targets: [
        .target(
            name: "Playbook"
        ),
        .target(
            name: "PlaybookSnapshot",
            dependencies: ["Playbook"]
        ),
        .target(
            name: "PlaybookUI",
            dependencies: ["Playbook"]
        )
    ],
    swiftLanguageVersions: [.v5]
)

if ProcessInfo.processInfo.environment["PLAYBOOK_DEVELOPMENT"] != nil {
    package.dependencies.append(contentsOf: [
        .package(url: "https://github.com/apple/swift-format.git", exact: "509.0.0"),
        .package(url: "https://github.com/yonaskolb/XcodeGen.git", exact: "2.38.0"),
        // XcodeGen fails to build with newer version of XcodeProj
        .package(url: "https://github.com/tuist/XcodeProj.git", exact: "8.15.0"),
    ])
}
