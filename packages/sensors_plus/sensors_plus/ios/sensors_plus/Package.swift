// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "sensors_plus",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "sensors-plus", targets: ["sensors_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "sensors_plus",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ]
        )
    ]
)
