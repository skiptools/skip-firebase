// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth
// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth

public final class Auth {
    public let auth: com.google.firebase.auth.FirebaseAuth

    public init(auth: com.google.firebase.auth.FirebaseAuth) {
        self.auth = auth
    }

    public static func auth() -> Auth {
        Auth(auth: com.google.firebase.auth.FirebaseAuth.getInstance())
    }

    public static func auth(app: FirebaseApp) -> Auth {
        Auth(auth: com.google.firebase.auth.FirebaseAuth.getInstance(app.app))
    }
}
#endif

