// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "Playbook",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "Playbook", targets: ["Playbook"]),
        .library(name: "PlaybookSnapshot", targets: ["Playbook"]),
        .library(name: "PlaybookUI", targets: ["Playbook"]),
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
