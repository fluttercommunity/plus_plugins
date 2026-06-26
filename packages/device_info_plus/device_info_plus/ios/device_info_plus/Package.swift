// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "device_info_plus",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "device-info-plus", targets: ["device_info_plus"])
    ],
    dependencies: [
            .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "device_info_plus",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            resources: [
                .process("PrivacyInfo.xcprivacy"),
            ],
            cSettings: [
                .headerSearchPath("include/device_info_plus")
            ]
        )
    ]
)
