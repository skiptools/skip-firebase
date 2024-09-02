// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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
