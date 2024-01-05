// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class FirebaseMessaging {
    public let messaging: com.google.firebase.messaging.FirebaseMessaging

    public init(messaging: com.google.firebase.messaging.FirebaseMessaging) {
        self.messaging = messaging
    }
}
#endif
