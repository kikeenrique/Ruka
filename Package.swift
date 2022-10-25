// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Ruka",
    platforms: [.iOS(.v15),
                .watchOS(.v8),
                .tvOS(.v15),
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
            dependencies: ["Ruka"]
        ),
    ]
)
