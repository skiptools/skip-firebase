// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class FirebaseDatabase {
    public let database: com.google.firebase.database.FirebaseDatabase

    public init(database: com.google.firebase.database.FirebaseDatabase) {
        self.database = database
    }
}
#endif
