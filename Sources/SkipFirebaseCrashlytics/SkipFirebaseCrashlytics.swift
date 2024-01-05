// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class Crashlytics {
    public let _crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics

    public init(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics) {
        self._crashlytics = crashlytics
    }

    public static func crashlytics() -> Crashlytics {
        Crashlytics(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics.getInstance())
    }
}
#endif
