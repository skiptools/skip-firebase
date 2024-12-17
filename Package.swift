// swift-tools-version: 5.9
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import PackageDescription
import Foundation

let skipstone = [Target.PluginUsage.plugin(name: "skipstone", package: "skip")]

let package = Package(
    name: "skip-firebase",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipFirebaseCore", targets: ["SkipFirebaseCore"]),
        .library(name: "SkipFirebaseFirestore", targets: ["SkipFirebaseFirestore"]),
        .library(name: "SkipFirebaseAuth", targets: ["SkipFirebaseAuth"]),
        .library(name: "SkipFirebaseAppCheck", targets: ["SkipFirebaseAppCheck"]),
        .library(name: "SkipFirebaseMessaging", targets: ["SkipFirebaseMessaging"]),
        .library(name: "SkipFirebaseCrashlytics", targets: ["SkipFirebaseCrashlytics"]),
        .library(name: "SkipFirebaseAnalytics", targets: ["SkipFirebaseAnalytics"]),
        .library(name: "SkipFirebaseRemoteConfig", targets: ["SkipFirebaseRemoteConfig"]),
        .library(name: "SkipFirebaseDatabase", targets: ["SkipFirebaseDatabase"]),
        .library(name: "SkipFirebaseFunctions", targets: ["SkipFirebaseFunctions"]),
        .library(name: "SkipFirebaseInstallations", targets: ["SkipFirebaseInstallations"]),
        .library(name: "SkipFirebaseStorage", targets: ["SkipFirebaseStorage"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.1.16"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.1.12"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "1.3.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.13.6"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.0.0")
    ],
    targets: [
        .target(name: "SkipFirebaseCore", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipModel", package: "skip-model"),
            // we would like to use "FirebaseCore", but it is not exposed as a product;
            // "FirebaseInstallations" is the next best thing, since it has few depencencies
            .product(name: "FirebaseInstallations", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseCoreTests", dependencies: [
            "SkipFirebaseCore",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseFirestore", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseFirestoreTests", dependencies: [
            "SkipFirebaseFirestore",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseAuth", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseAuthTests", dependencies: [
            "SkipFirebaseAuth",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseAppCheck", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseAppCheck", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseAppCheckTests", dependencies: [
            "SkipFirebaseAppCheck",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseMessaging", dependencies: [
            "SkipFirebaseCore",
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "FirebaseMessaging", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseMessagingTests", dependencies: [
            "SkipFirebaseMessaging",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseCrashlytics", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseCrashlyticsTests", dependencies: [
            "SkipFirebaseCrashlytics",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseAnalytics", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseAnalyticsTests", dependencies: [
            "SkipFirebaseAnalytics",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseRemoteConfig", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseRemoteConfigTests", dependencies: [
            "SkipFirebaseRemoteConfig",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseDatabase", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseDatabaseTests", dependencies: [
            "SkipFirebaseDatabase",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseFunctions", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseFunctions", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseFunctionsTests", dependencies: [
            "SkipFirebaseFunctions",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseInstallations", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseInstallations", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseInstallationsTests", dependencies: [
            "SkipFirebaseInstallations",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),

        .target(name: "SkipFirebaseStorage", dependencies: [
            "SkipFirebaseCore",
            .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
        ], resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipFirebaseStorageTests", dependencies: [
            "SkipFirebaseStorage",
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: skipstone),
    ]
)

if ProcessInfo.processInfo.environment["SKIP_BRIDGE"] ?? "0" != "0" {
    package.dependencies += [.package(url: "https://source.skip.tools/skip-bridge.git", "0.0.0"..<"2.0.0")]
    for target in package.targets {
        if target.name == "SkipFirebaseCore" || target.name == "SkipFirebaseFirestore" {
            target.dependencies += [.product(name: "SkipBridge", package: "skip-bridge")]
        }
    }
}
