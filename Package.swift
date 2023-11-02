// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription
import Foundation

let skipstone = [Target.PluginUsage.plugin(name: "skipstone", package: "skip")]

let package = Package(
    name: "skip-base",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipBase", type: .dynamic, targets: ["SkipBase"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.16"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.17.0")
    ],
    targets: [
        .target(name: "SkipBase", dependencies: [.product(name: "SkipFoundation", package: "skip-foundation"), .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipBaseTests", dependencies: ["SkipBase", .product(name: "SkipTest", package: "skip")], resources: [.process("Resources")], plugins: skipstone),
    ]
)
