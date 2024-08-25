# SkipFirebase

This package provides Firebase support for Skip app/framework projects.
The Swift side uses the official Firebase iOS SDK directly,
with the various `SkipFirebase*` modules passing the transpiled calls
through to the Firebase Android SDK.

For an example of using Firebase in a Skip app, see the
[Fireside Sample](https://github.com/skiptools/skipapp-fireside/).

## Package

An example of a Skip app projects using the `Firestore` and `Messaging` API can be seen
from the command:

```console
skip init --show-tree --icon-color='1abc9c' --no-zero --appid=skip.fireside.App --version 0.0.1 skipapp-fireside FireSide:skip-ui/SkipUI FireSideModel:skip-foundation/SkipFoundation:skip-model/SkipModel:skip-firebase/SkipFirebaseFirestore:skip-firebase/SkipFirebaseMessaging:skip-firebase/SkipFirebaseAuth
```

This will create an SwiftPM project in `skipapp-fireside/Package.swift` like:

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "skipapp-fireside",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "FireSideApp", type: .dynamic, targets: ["FireSide"]),
        .library(name: "FireSideModel", targets: ["FireSideModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "1.0.0"),
        .package(url: "https://source.skip.tools/skip-firebase.git", "0.0.0"..<"2.0.0")
    ],
    targets: [
        .target(name: "FireSide", dependencies: [
            "FireSideModel", 
            .product(name: "SkipFoundation", package: "skip-foundation"),
            .product(name: "SkipUI", package: "skip-ui")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "FireSideTests", dependencies: [
            "FireSide", 
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        
        .target(name: "FireSideModel", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation"), 
            .product(name: "SkipModel", package: "skip-model"), 
            .product(name: "SkipFirebaseFirestore", package: "skip-firebase"), 
            .product(name: "SkipFirebaseMessaging", package: "skip-firebase"), 
            .product(name: "SkipFirebaseAuth", package: "skip-firebase")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "FireSideModelTests", dependencies: [
            "FireSideModel", 
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)

```

## Usage

For a Skip app, the simplest way to setup Firebase support is to
create a Firebase project at https://console.firebase.google.com/project.
Follow the Firebase setup instructions to obtain the 
`GoogleService-Info.plist` and `google-services.json` files and
add them to the iOS and Android sides of the project:

- the `GoogleService-Info.plist` file should be placed in the `Darwin/` folder of the Skip project
- the `google-services.json` file should be placed in the `Android/app/` folder of the Skip project

In addition, the `com.google.gms.google-services` plugin will need to be added to the 
Android app's `Android/app/build.gradle.kts` file in order to process the `google-services.json`
file for the app, like so:

```kotlin
plugins {
    alias(libs.plugins.kotlin.android)
    alias(libs.plugins.android.application)
    id("skip-build-plugin")
    id("com.google.gms.google-services") version "4.4.1" apply true
}
```

For concrete examples, see the [Fireside Sample](https://github.com/skiptools/skipapp-fireside/) project.

Once the Firebase properties are correctly configured, you will then be able to access the singleton type for each of the
imported Firebase modules. This is typically done using an app-wide singleton within a shared class or actor:

```swift
import OSLog
import Foundation
import SkipFirebaseFirestore

public actor Model {
    /// The shared model singleton
    public static let shared = Model()

    let logger: Logger = Logger(subsystem: "my.app", category: "Model")

    /// The global Firestore instance for the app, configured using the default
    /// `Android/app/google-services.json` and `Darwin/GoogleService-Info.plist` configuration files
    /// which can be downloaded for your project from https://console.firebase.google.com/project/
    public let firestore: Firestore

    private init() throws {
        logger.log("invoking FirebaseApp.configure()")
        FirebaseApp.configure()
        self.firestore = Firestore.firestore()
    }
    
    public func queryData() async throws -> [DataModel] { … }
    public func saveData(model: DataModel) async throws { … }
}

```


### Common Errors 

```plaintext
Error in adb logcat: FirebaseApp: Default FirebaseApp failed to initialize because no default options were found.
This usually means that com.google.gms:google-services was not applied to your gradle project.
```

The app's `com.google.gms:google-services` plugin must be applied to the `build.gradle.kts` file for the app's target.


### Testing

For unit testing, where there isn't a standard place to store the
`GoogleService-Info.plist` and `google-services.json` configuration files,
you can create an configure the app using the `SkipFirebaseCore.FirebaseApp`
API manually from the information provided from the Firebase console, like so:

```swift
import SkipFirebaseCore
import SkipFirebaseAuth
import SkipFirebaseStorage
import SkipFirebaseDatabase
import SkipFirebaseAppCheck
import SkipFirebaseFunctions
import SkipFirebaseFirestore
import SkipFirebaseMessaging
import SkipFirebaseCrashlytics
import SkipFirebaseRemoteConfig
import SkipFirebaseInstallations

let appName = "myapp"
let options = FirebaseOptions(googleAppID: "1:GCM:ios:HASH", gcmSenderID: "GCM")
options.projectID = "some-firebase-projectid"
options.storageBucket = "some-firebase-demo.appspot.com"
options.apiKey = "some-api-key"

FirebaseApp.configure(name: appName, options: options)
guard let app = FirebaseApp.app(name: appName) else {
    fatalError("Cannot load Firebase config")
}

// customize the app here
app.isDataCollectionDefaultEnabled = false

// use the app to create and test services
let auth = Auth.auth(app: app)
let storage = Storage.storage(app: app)
let database = Database.database(app: app)
let appcheck = AppCheck.appCheck(app: app)
let functions = Functions.functions(app: app)
let firestore = Firestore.firestore(app: app)
let crashlytics = Crashlytics.crashlytics(app: app)
let remoteconfig = RemoteConfig.remoteConfig(app: app)
let installations = Installations.installations(app: app)

```


## Package

The modules in the SkipFirebase framework project mirror the division of the SwiftPM
modules in the Firebase iOS SDK (at [https://github.com/firebase/firebase-ios-sdk.git](https://github.com/firebase/firebase-ios-sdk.git)),
which is also mirrored in the division of the Firebase Kotlin Android gradle modules (at [https://github.com/firebase/firebase-android-sdk.git](https://github.com/firebase/firebase-android-sdk.git)).

For example, SkipFirebaseCore provides parity with the iOS SDK's FirebaseCore Swift API. Example usage:

```swift
#if !SKIP
import FirebaseCore
#else
import SkipFirebaseCore
#endif

// use the default FirebaseApp configured for the app
let app: FirebaseApp? = FirebaseApp.app()

// …or use create a customized FirebaseApp
let options = FirebaseOptions(googleAppID: "1:GCM:ios:HASH", gcmSenderID: "GCM")

options.projectID = "some-firebase-projectid"
options.storageBucket = "some-firebase-demo.appspot.com"
options.apiKey = "some-api-key"

FirebaseApp.configure(name: appName, options: options)

guard let app = FirebaseApp.app(name: appName) else {
    fatalError("Cannot load Firebase config")
}

```

## Building

This project is a free Swift Package Manager module that uses the
[Skip](https://skip.tools) plugin to transpile Swift into Kotlin.

Building the module requires that Skip be installed using 
[Homebrew](https://brew.sh) with `brew install skiptools/skip/skip`.
This will also install the necessary build prerequisites:
Kotlin, Gradle, and the Android build tools.


## Testing

The module can be tested using the standard `swift test` command
or by running the test target for the macOS destination in Xcode,
which will run the Swift tests as well as the transpiled
Kotlin JUnit tests in the Robolectric Android simulation environment.

Parity testing can be performed with `skip test`,
which will output a table of the test results for both platforms.
