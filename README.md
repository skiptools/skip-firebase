# SkipFirebase

This package provides Firebase support for Skip app/framework projects.
The Swift side uses the official Firebase iOS SDK directly,
with the various `SkipFirebase*` modules passing the transpiled calls
through to the Firebase Android SDK.

For an example of using Firebase in a Skip app, see the
[Fireside Sample](https://github.com/skiptools/skipapp-fireside/).

## Package

The modules in the SkipFirebase framework project mirror the division of the SwiftPM
modules in the Firebase iOS SDK (at [https://github.com/firebase/firebase-ios-sdk.git](https://github.com/firebase/firebase-ios-sdk.git)),
which is also mirrored in the division of the Firebase Kotlin Android gradle modules (at [https://github.com/firebase/firebase-android-sdk.git](https://github.com/firebase/firebase-android-sdk.git)).

An example of a Skip app projects using the `Firestore` API at the model layer and the `Messaging` API at the app layer can be seen from the command:

```console
skip init --show-tree --icon-color='1abc9c' --no-zero --appid=skip.fireside.App --version 0.0.1 skipapp-fireside FireSide:skip-ui/SkipUI:skip-firebase/SkipFirebaseMessaging FireSideModel:skip-foundation/SkipFoundation:skip-model/SkipModel:skip-firebase/SkipFirebaseFirestore:skip-firebase/SkipFirebaseAuth
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
            .product(name: "SkipUI", package: "skip-ui"),
            .product(name: "SkipFirebaseMessaging", package: "skip-firebase")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "FireSideTests", dependencies: [
            "FireSide", 
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        
        .target(name: "FireSideModel", dependencies: [
            .product(name: "SkipFoundation", package: "skip-foundation"), 
            .product(name: "SkipModel", package: "skip-model"), 
            .product(name: "SkipFirebaseFirestore", package: "skip-firebase"),  
            .product(name: "SkipFirebaseAuth", package: "skip-firebase")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "FireSideModelTests", dependencies: [
            "FireSideModel", 
            .product(name: "SkipTest", package: "skip")
        ], resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
```

## Setup

For a Skip app, the simplest way to setup Firebase support is to
create a Firebase project at [https://console.firebase.google.com/project](https://console.firebase.google.com/project).
Follow the Firebase setup instructions to obtain the 
`GoogleService-Info.plist` and `google-services.json` files and
add them to the iOS and Android sides of the project:

- The `GoogleService-Info.plist` file should be placed in the `Darwin/` folder of the Skip project
- The `google-services.json` file should be placed in the `Android/app/` folder of the Skip project

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

For concrete examples, see the [FireSide Sample](https://github.com/skiptools/skipapp-fireside/) project.
{: class="callout info"}

Once Firebase has been added to your project, you need to configure the `FirebaseApp` on app startup. For iOS, this is typically done by setting an app delegate in your `Darwin/Sources/AppMain.swift` file. Here is a snippet from the FireSide sample app:

```swift
import FirebaseCore
...

@main struct AppMain: App, FireSideApp {
    @UIApplicationDelegateAdaptor(FireSideAppDelegate.self) var appDelegate
}

class FireSideAppDelegate : NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        ...
        return true
    }
}
```

And for Android, configure `FirebaseApp` in your `Application.onCreate` function in `Android/app/src/main/kotlin/.../Main.kt`:

```kotlin
import skip.firebase.core.FirebaseApp
...

open class AndroidAppMain: Application {
    constructor() {
    }

    override fun onCreate() {
        super.onCreate()
        ProcessInfo.launch(applicationContext)

        FirebaseApp.configure()
        ...
    }
}
```

After configuring the `FirebaseApp`, you will be able to access the singleton type for each of the
imported Firebase modules. For example, the following actor uses the `Firestore` singleton:

```swift
#if SKIP
import SkipFirebaseFirestore
#else
import FirebaseFirestore
#endif
...

public actor Model {
    /// The shared model singleton
    public static let shared = Model()

    private let firestore: Firestore

    private init() {
        self.firestore = Firestore.firestore()
    }
    
    public func queryData() async throws -> [DataModel] { ... }
    public func saveData(model: DataModel) async throws { ... }
    ...
}

```

## Messaging

After [setting up](#setup) your app to use Firebase, enabling push notifications via Firebase Cloud Messaging (FCM) requires a number of additional steps.

1. Follow Firebase's [instructions](https://firebase.google.com/docs/cloud-messaging/ios/client) for creating and uploading your Apple Push Notification Service (APNS) key.
1. Use Xcode to [add the Push capability](https://developer.apple.com/documentation/xcode/adding-capabilities-to-your-app/) to your iOS app.
1. Add Skip's Firebase messaging service and default messaging channel to `Android/app/src/main/AndroidManifest.xml`:

    ```xml
    ...
    <application ...>
        ...
        <service
            android:name="skip.firebase.messaging.MessagingService"
            android:exported="false">
            <intent-filter>
                <action android:name="com.google.firebase.MESSAGING_EVENT" />
            </intent-filter>
        </service>
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="tools.skip.firebase.messaging" />
    </application>
    ```

1. Consider increasing the `minSdk` version of your Android app. Prior to SDK 33, Android does not provide any control over asking the user for push notification permissions. Rather, the system will prompt the user for permission only after receiving a notification and opening the app. Increasing your `minSdk` will allow you to decide when to request notification permissions. To do so, edit your `Android/app/build.gradle.kts` file and change the `minSdk` value to 33.
1. Define a delegate to receive notification callbacks. In keeping with Skip's philosophy of *transparent adoption*, both the iOS and Android sides of your app will receive callbacks via iOS's standard `UNUserNotificationCenterDelegate` API, as well as the Firebase iOS SDK's `MessagingDelegate`. Here is an example delegate implementation that works across both platforms:

    ```swift
    import SwiftUI
    #if SKIP
    import SkipFirebaseMessaging
    #else
    import FirebaseMessaging
    #endif

    public class NotificationDelegate : NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
        public func requestPermission() {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            Task { @MainActor in
                do {
                    if try await UNUserNotificationCenter.current().requestAuthorization(options: authOptions) {
                        logger.info("notification permission granted")
                    } else {
                        logger.info("notification permission denied")
                    }
                } catch {
                    logger.error("notification permission error: \(error)")
                }
            }
        }

        @MainActor
        public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
            let content = notification.request.content
            logger.info("willPresentNotification: \(content.title): \(content.body) \(content.userInfo)")
            return [.banner, .sound]
        }

        @MainActor
        public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
            let content = response.notification.request.content
            logger.info("didReceiveNotification: \(content.title): \(content.body) \(content.userInfo)")
        }

        public func messaging(_ messaging: Messaging, didReceiveRegistrationToken token: String?) {
            logger.info("didReceiveRegistrationToken: \(token ?? "nil")")
        }
    }
    ```

1. Wire everything up. This includes assigning your shared delegate, registering for remote notifications, and other necessary steps. Below we build on our [previous Firebase setup code](#setup) to perform these actions. This is taken from our FireSide sample app:

    ```swift
    // Darwin/Sources/FireSideAppMain.swift

    import FirebaseCore
    import FirebaseMessaging
    import FireSide
    ...

    @main struct AppMain: App, FireSideApp {
        @UIApplicationDelegateAdaptor(FireSideAppDelegate.self) var appDelegate
    }

    class FireSideAppDelegate : NSObject, UIApplicationDelegate {
        let notificationsDelegate = NotificationDelegate() // Defined in FireSideApp.swift

        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()

            UNUserNotificationCenter.current().delegate = notificationsDelegate
            Messaging.messaging().delegate = notificationsDelegate

            // Ask for permissions at a time appropriate for your app
            notificationsDelegate.requestPermission()

            application.registerForRemoteNotifications()
            return true
        }
    }
    ```

    ```kotlin
    // Android/app/src/main/kotlin/.../Main.kt

    import skip.firebase.core.FirebaseApp
    import skip.firebase.messaging.Messaging
    ...

    internal val notificationsDelegate = NotificationDelegate() // Defined in FireSideApp.swift

    open class AndroidAppMain: Application {
        constructor() {
        }

        override fun onCreate() {
            super.onCreate()
            ProcessInfo.launch(applicationContext)

            FirebaseApp.configure()
            UNUserNotificationCenter.current().delegate = notificationsDelegate
            Messaging.messaging().delegate = notificationsDelegate
        }
    }

    open class MainActivity: AppCompatActivity {
        constructor() {
        }

        override fun onCreate(savedInstanceState: android.os.Bundle?) {
            super.onCreate(savedInstanceState)
            UIApplication.launch(this) // <-- Add this too if not present
            enableEdgeToEdge()

            setContent {
                val saveableStateHolder = rememberSaveableStateHolder()
                saveableStateHolder.SaveableStateProvider(true) {
                    PresentationRootView(ComposeContext())
                }
            }

            Messaging.messaging().onActivityCreated(this)
            // Ask for permissions at a time appropriate for your app
            notificationsDelegate.requestPermission()

            ...
        }

        ...
    }
    ```

    Note that the call to `UIApplication.launch` in `MainActivity.onCreate` may not be present if you have an older Skip project. Be sure to add it if it is not already there.

1. See Firebase's [iOS instructions](https://firebase.google.com/docs/cloud-messaging/ios/client) and [Android instructions](https://firebase.google.com/docs/cloud-messaging/android/client) for additional details and options, including how to send test messages to your apps!

The [Fireside Sample](https://github.com/skiptools/skipapp-fireside/) project is a great reference for seeing a complete, working app using Firebase push notifications.
{: class="callout info"}

## Error handling

### Firestore

The Firestore API converts `com.google.firebase.firestore.FirebaseFirestoreException` to NSError so you can handle errors the same way on both platforms:

```swift
do {
    try await Firestore.firestore().collection("foo").document("bar").updateData(...)
} catch let error as NSError {
    if error.domain == FirestoreErrorDomain && error.code == FirestoreErrorCode.notFound.rawValue {
        ...
    }
}
```

### Catching other errors

Other parts of this library have not been updated to this unified error handling. Instead, you can access the underlying Kotlin exceptions in SKIP blocks according to the documentation:

- FirebaseAuth: https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth
- FirebaseMessaging.MessagingService.onSendError: https://firebase.google.com/docs/reference/android/com/google/firebase/messaging/SendException
- FirebaseStorage: https://firebase.google.com/docs/reference/android/com/google/firebase/storage/StorageException

```swift
do {
    try await Storage.storage().reference().child("nonexistent").delete()
} catch {
    #if !SKIP
    let error = error as NSError
    let errorCode = error.domain == StorageError.errorDomain ? error.code : nil
    #else
    let exception = (error as Exception).cause as? com.google.firebase.storage.StorageException
    let errorCode = exception?.code.value()
    #endif
    if errorCode == -13010 { 
        // Object not found
    }
}
```

## Testing

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

## Common Errors 

```plaintext
Error in adb logcat: FirebaseApp: Default FirebaseApp failed to initialize because no default options were found.
This usually means that com.google.gms:google-services was not applied to your gradle project.
```

The app's `com.google.gms:google-services` plugin must be applied to the `build.gradle.kts` file for the app's target.

## License

This software is licensed under the
[GNU Lesser General Public License v3.0](https://spdx.org/licenses/LGPL-3.0-only.html),
with the following
[linking exception](https://spdx.org/licenses/LGPL-3.0-linking-exception.html)
to clarify that distribution to restricted environments (e.g., app stores)
is permitted:

> This software is licensed under the LGPL3, included below.
> As a special exception to the GNU Lesser General Public License version 3
> ("LGPL3"), the copyright holders of this Library give you permission to
> convey to a third party a Combined Work that links statically or dynamically
> to this Library without providing any Minimal Corresponding Source or
> Minimal Application Code as set out in 4d or providing the installation
> information set out in section 4e, provided that you comply with the other
> provisions of LGPL3 and provided that you meet, for the Application the
> terms and conditions of the license(s) which apply to the Application.
> Except as stated in this special exception, the provisions of LGPL3 will
> continue to comply in full to this Library. If you modify this Library, you
> may apply this exception to your version of this Library, but you are not
> obliged to do so. If you do not wish to do so, delete this exception
> statement from your version. This exception does not (and cannot) modify any
> license terms which apply to the Application, with which you must still
> comply.

