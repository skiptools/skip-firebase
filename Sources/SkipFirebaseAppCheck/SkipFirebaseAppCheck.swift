// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class AppCheck {
    public let appcheck: com.google.firebase.appcheck.FirebaseAppCheck

    public init(appcheck: com.google.firebase.appcheck.FirebaseAppCheck) {
        self.appcheck = appcheck
    }

    public static func appCheck() -> AppCheck {
        AppCheck(appcheck: com.google.firebase.appcheck.FirebaseAppCheck.getInstance())
    }
}
#endif
