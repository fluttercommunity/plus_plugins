// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "network_info_plus",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "network-info-plus", targets: ["network_info_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "network_info_plus",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/network_info_plus")
            ]
        )
    ]
)
