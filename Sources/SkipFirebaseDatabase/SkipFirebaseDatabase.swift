// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseDatabase)
@_exported import FirebaseDatabase
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasedatabase/api/reference/Classes/Database
// https://firebase.google.com/docs/reference/android/com/google/firebase/database/FirebaseDatabase

public final class Database {
    public let database: com.google.firebase.database.FirebaseDatabase

    public init(database: com.google.firebase.database.FirebaseDatabase) {
        self.database = database
    }

    public static func database() -> Database {
        Database(database: com.google.firebase.database.FirebaseDatabase.getInstance())
    }

    public static func database(app: FirebaseApp) -> Database {
        Database(database: com.google.firebase.database.FirebaseDatabase.getInstance(app.app))
    }
}
#endif
#endif
