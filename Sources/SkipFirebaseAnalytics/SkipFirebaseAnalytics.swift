// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Classes/Analytics
// https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics

public final class Analytics {
    public let analytics: com.google.firebase.analytics.FirebaseAnalytics

    public init(analytics: com.google.firebase.analytics.FirebaseAnalytics) {
        self.analytics = analytics
    }

//    public static func analytics() -> Analytics {
//        Analytics(analytics: com.google.firebase.analytics.FirebaseAnalytics.getInstance())
//    }

    public static func logEvent(_ name: String, parameters: [String: Any] = [:]) {
        let bundle = android.os.Bundle()
        // TODO: add parameters to bundle
        com.google.firebase.analytics.FirebaseAnalytics.getInstance(skip.foundation.ProcessInfo.processInfo.androidContext).logEvent(name, bundle)
    }
}
#endif
#endif
