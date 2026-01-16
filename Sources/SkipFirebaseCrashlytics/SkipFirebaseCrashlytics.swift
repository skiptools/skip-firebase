// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if canImport(FirebaseCrashlytics)
@_exported import FirebaseCrashlytics
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasecrashlytics/api/reference/Classes/Crashlytics
// https://firebase.google.com/docs/reference/android/com/google/firebase/crashlytics/FirebaseCrashlytics

public final class Crashlytics {
    public let _crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics

    public init(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics) {
        self._crashlytics = crashlytics
    }

    public static func crashlytics() -> Crashlytics {
        Crashlytics(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics.getInstance())
    }

//    public static func crashlytics(app: FirebaseApp) -> Crashlytics {
//        Crashlytics(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics.getInstance(app.app))
//    }
}
#endif
#endif
