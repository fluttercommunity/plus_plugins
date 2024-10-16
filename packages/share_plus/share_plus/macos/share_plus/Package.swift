// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "share_plus",
    platforms: [
        .macOS("10.14")
    ],
    products: [
        .library(name: "share-plus", targets: ["share_plus"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "share_plus",
            dependencies: [],
            resources: [
               .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
