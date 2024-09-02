// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
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
