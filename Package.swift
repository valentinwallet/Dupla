// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Dupla",
    platforms: [
        .macOS(.v14),
        .iOS(.v17),
    ],
    products: [
        .library(name: "DuplaDesign", targets: ["DuplaDesign"]),
    ],
    targets: [
        .target(
            name: "DuplaDesign",
            resources: [
                .copy("Resources/Fonts"),
                .process("Resources/Colors.xcassets"),
                .process("Resources/Materials.xcassets"),
            ]
        ),
    ]
)
