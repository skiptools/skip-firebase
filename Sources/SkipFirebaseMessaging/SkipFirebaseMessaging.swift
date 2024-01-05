// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasemessaging/api/reference/Classes/Messaging
// https://firebase.google.com/docs/reference/android/com/google/firebase/messaging/FirebaseMessaging

public final class Messaging {
    public let messaging: com.google.firebase.messaging.FirebaseMessaging

    public init(messaging: com.google.firebase.messaging.FirebaseMessaging) {
        self.messaging = messaging
    }

    public static func messaging() -> Messaging {
        Messaging(messaging: com.google.firebase.messaging.FirebaseMessaging.getInstance())
    }

//    public static func messaging(app: FirebaseApp) -> Messaging {
//        Messaging(messaging: com.google.firebase.messaging.FirebaseMessaging.getInstance(app.app))
//    }

    public func subscribe(toTopic topic: String) async throws {
        messaging.subscribeToTopic(topic).await()
    }

    public func unsubscribe(fromTopic topic: String) async throws {
        messaging.unsubscribeFromTopic(topic).await()
    }
}
#endif

//import FirebaseMessaging
//private func demoFirebaseMessaging() {
//    let _ = Messaging.messaging().appDidReceiveMessage([AnyHashable : Any])
//}
