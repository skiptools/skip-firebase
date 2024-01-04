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
        //.library(name: "SkipFirebaseAuth", targets: ["SkipFirebaseAuth"]),
        //.library(name: "SkipFirebaseAppCheck", targets: ["SkipFirebaseAppCheck"]),
        //.library(name: "SkipFirebaseMessaging", targets: ["SkipFirebaseMessaging"]),
        //.library(name: "SkipFirebaseCrashlytics", targets: ["SkipFirebaseCrashlytics"]),
        //.library(name: "SkipFirebaseAnalytics", targets: ["SkipFirebaseAnalytics"]),
        //.library(name: "SkipFirebaseRemoteConfig", targets: ["SkipFirebaseRemoteConfig"]),
        //.library(name: "SkipFirebaseDatabase", targets: ["SkipFirebaseDatabase"]),
        //.library(name: "SkipFirebaseFunctions", targets: ["SkipFirebaseFunctions"]),
        //.library(name: "SkipFirebaseInstallations", targets: ["SkipFirebaseInstallations"]),
        //.library(name: "SkipFirebasePerformance", targets: ["SkipFirebasePerformance"]),
        //.library(name: "SkipFirebaseStorage", targets: ["SkipFirebaseStorage"]),
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
