# SkipFirebase

This package provides Firebase support for Skip app/framework projects.
The Swift side uses the official Firebase iOS SDK directly,
with the various `SkipFirebase*` modules passing the transpiled calls
through to the Firebase Android SDK.

## Modules

### SkipFirebaseAnalytics

Provides limited parity to the [FirebaseAnalytics](https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Classes/Analytics) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseAppCheck

Provides limited parity to the [FirebaseAppCheck](https://firebase.google.com/docs/reference/swift/firebaseappcheck/api/reference/Classes/AppCheck) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseAuth

Provides limited parity to the [FirebaseAuth](https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseCore

Provides limited parity to the [FirebaseCore](https://firebase.google.com/docs/reference/swift/firebasecore/api/reference/Classes/Core) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseCrashlytics

Provides limited parity to the [FirebaseCrashlytics](https://firebase.google.com/docs/reference/swift/firebasecrashlytics/api/reference/Classes/Crashlytics) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseDatabase

Provides limited parity to the [FirebaseDatabase](https://firebase.google.com/docs/reference/swift/firebasedatabase/api/reference/Classes/Database) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseFirestore

Provides limited parity to the [FirebaseFirestore](https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/Firestore) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseFunctions

Provides limited parity to the [FirebaseFunctions](https://firebase.google.com/docs/reference/swift/firebasefunctions/api/reference/Classes/Functions) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseInstallations

Provides limited parity to the [FirebaseInstallations](https://firebase.google.com/docs/reference/swift/firebaseinstallations/api/reference/Classes/Installations) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseMessaging

Provides limited parity to the [FirebaseMessaging](https://firebase.google.com/docs/reference/swift/firebasemessaging/api/reference/Classes/Messaging) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseRemoteConfig

Provides limited parity to the [FirebaseRemoteConfig](https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfig) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

```

### SkipFirebaseStorage

Provides limited parity to the [FirebaseStorage](https://firebase.google.com/docs/reference/swift/firebasestorage/api/reference/Classes/Storage) API.

Example Package.swift dependency:

```swift

```

Example usage:

```swift

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
