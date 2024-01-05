// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class Messaging {
    public let messaging: com.google.firebase.messaging.FirebaseMessaging

    public init(messaging: com.google.firebase.messaging.FirebaseMessaging) {
        self.messaging = messaging
    }

    public static func messaging() -> Messaging {
        Messaging(messaging: com.google.firebase.messaging.FirebaseMessaging.getInstance())
    }
}
#endif
