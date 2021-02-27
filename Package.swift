// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "swift-jvm",
    platforms: [
        .macOS(.v11),
        .iOS(.v10),
    ],
    products: [
        .library(
            name: "JVM",
            targets: ["JVM"]
        ),
        .executable(name: "java",
                    targets: ["java"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
    ],
    targets: [
        .target(
            name: "JVM",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "java",
            dependencies: [
                .target(name: "JVM"),
            ]
        ),
        .testTarget(
            name: "JVMTests",
            dependencies: ["JVM"]
        ),
    ]
)
