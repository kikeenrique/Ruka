// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Ruka",
    platforms: [.iOS(.v14),
                .watchOS(.v8),
                .tvOS(.v14),
                .macCatalyst(.v13)],
    products: [
        .library(
            name: "Ruka",
            targets: ["Ruka"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Ruka",
            dependencies: []
        ),
        .testTarget(
            name: "RukaTests",
            dependencies: ["Ruka"],
            resources: [
                .process("Resources")
            ]
        ),
    ]
)
