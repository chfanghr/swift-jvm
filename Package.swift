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
        .executable(
            name: "java",
            targets: ["java"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.0")),
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/marmelroy/Zip", .upToNextMinor(from: "2.1.0")),
        .package(url: "https://github.com/tsolomko/BitByteData.git", from: "1.4.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.1"),
    ],
    targets: [
        .target(
            name: "JVM",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .target(name: "Classpath"),
                .target(name: "JVMError"),
                .target(name: "Utilities")
            ]),
        .target(
            name: "ClassFile",
            dependencies: [
                .product(name: "BitByteData", package: "BitByteData"),
                .target(name: "JVMError"),
                .target(name: "Utilities")
            ]),
        .target(
            name: "Classpath",
            dependencies: [
                .product(name: "Files", package: "Files"),
                .product(name: "Zip", package: "Zip"),
                .target(name: "JVMError"),
                .target(name: "Utilities")
            ]),
        .target(
            name: "JVMError",
            dependencies: [
                .target(name: "Utilities")
            ]
        ),
        .target(
            name: "java",
            dependencies: [
                .target(name: "JVM"),
            ]
        ),
        .target(
            name: "Utilities",
            dependencies:[
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "JVMTests",
            dependencies: ["JVM"]
        ),
    ]
)
