// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-cpu-binary-serializer",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [
        .library(
            name: "CPU Binary Serializer",
            targets: ["CPU Binary Serializer"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-atoms/swift-cpu.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-binary.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-binary-serializer.git",
            branch: "main"
        ),
    ],
    targets: [
        .target(
            name: "CPU Binary Serializer",
            dependencies: [
                .product(name: "CPU", package: "swift-cpu"),
                .product(name: "Binary", package: "swift-binary"),
                .product(
                    name: "Binary Serializable",
                    package: "swift-binary-serializer"
                ),
            ]
        ),
        .testTarget(
            name: "CPU Binary Serializer Tests",
            dependencies: [
                "CPU Binary Serializer",
                .product(name: "CPU", package: "swift-cpu"),
                .product(name: "Binary", package: "swift-binary"),
                .product(
                    name: "Binary Serializable",
                    package: "swift-binary-serializer"
                ),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
