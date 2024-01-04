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
        .library(name: "SkipFirebaseCore", targets: ["SkipFirebaseCore"]),
        .library(name: "SkipFirebaseFirestore", targets: ["SkipFirebaseFirestore"]),
        // "FirebaseAnalytics"
        // "FirebaseAnalyticsWithoutAdIdSupport"
        // "FirebaseAnalyticsOnDeviceConversion"
        // "FirebaseAuth"
        // "FirebaseAppCheck"
        // "FirebaseAppDistribution-Beta"
        // "FirebaseCrashlytics"
        // "FirebaseDatabase"
        // "FirebaseDynamicLinks"
        // "FirebaseFirestore"
        // "FirebaseFunctions"
        // "FirebaseInAppMessaging-Beta"
        // "FirebaseInstallations"
        // "FirebaseMessaging"
        // "FirebaseMLModelDownloader"
        // "FirebasePerformance"
        // "FirebaseRemoteConfig"
        // "FirebaseRemoteConfig"
        // "FirebaseStorage"
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.7.16"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.0.0"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.0.0"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.17.0")
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
    ]
)
