// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "battery_plus",
  platforms: [
    .macOS("10.14")
  ],
  products: [
    .library(name: "battery-plus", targets: ["battery_plus"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "battery_plus",
      dependencies: [],
      resources: [
        .process("PrivacyInfo.xcprivacy")
      ]
    )
  ]
)
