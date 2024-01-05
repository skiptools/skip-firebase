// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasestorage/api/reference/Classes/Storage
// https://firebase.google.com/docs/reference/android/com/google/firebase/storage/FirebaseStorage

public final class Storage {
    public let storage: com.google.firebase.storage.FirebaseStorage

    public init(storage: com.google.firebase.storage.FirebaseStorage) {
        self.storage = storage
    }

    public static func storage() -> Storage {
        Storage(storage: com.google.firebase.storage.FirebaseStorage.getInstance())
    }

    public static func storage(app: FirebaseApp) -> Storage {
        Storage(storage: com.google.firebase.storage.FirebaseStorage.getInstance(app.app))
    }

    public var app: FirebaseApp {
        FirebaseApp(app: storage.getApp())
    }

}
#endif

//import FirebaseStorage
//_ = Storage.storage()!.app
