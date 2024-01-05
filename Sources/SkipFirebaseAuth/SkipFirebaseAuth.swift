// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class FirebaseAuth {
    public let auth: com.google.firebase.auth.FirebaseAuth

    public init(auth: com.google.firebase.auth.FirebaseAuth) {
        self.auth = auth
    }
}
#endif
