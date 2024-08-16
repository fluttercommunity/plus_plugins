// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "package_info_plus",
    platforms: [
        .iOS("12.0"),
    ],
    products: [
        .library(name: "package-info-plus", targets: ["package_info_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "package_info_plus",
            dependencies: [],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/package_info_plus")
            ]
        )
    ]
)
