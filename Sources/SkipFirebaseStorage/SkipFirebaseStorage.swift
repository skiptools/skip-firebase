// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import SkipFoundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await
import android.net.Uri

// https://firebase.google.com/docs/reference/swift/firebasestorage/api/reference/Classes/Storage
// https://firebase.google.com/docs/reference/android/com/google/firebase/storage/FirebaseStorage

public final class Storage {
    public let platformValue: com.google.firebase.storage.FirebaseStorage

    public init(platformValue: com.google.firebase.storage.FirebaseStorage) {
        self.platformValue = platformValue
    }

    public static func storage() -> Storage {
        Storage(com.google.firebase.storage.FirebaseStorage.getInstance())
    }

    public static func storage(app: FirebaseApp) -> Storage {
        Storage(com.google.firebase.storage.FirebaseStorage.getInstance(app.app))
    }

    public var app: FirebaseApp {
        FirebaseApp(app: platformValue.getApp())
    }

	public func reference() -> StorageReference {
		return StorageReference(platformValue.reference)
	}
}

public class StorageReference: KotlinConverting<com.google.firebase.storage.StorageReference> {
	
	public let platformValue: com.google.firebase.storage.StorageReference
	
	public init(platformValue: com.google.firebase.storage.StorageReference) {
		self.platformValue = platformValue
	}
	
	public override func kotlin(nocopy: Bool = false) -> com.google.firebase.storage.StorageReference {
		platformValue
	}
	
	public var description: String {
		platformValue.toString()
	}
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		lhs.platformValue == rhs.platformValue
	}
	
	public var storage: Storage {
		Storage(platformValue.storage)
	}
	
	public var bucket: String {
		return platformValue.bucket
	}
	
	public var fullPath: String {
		return platformValue.path
	}
	
	public var name: String {
		return platformValue.name
	}
	
	public func root() -> StorageReference {
		return StorageReference(platformValue.root)
	}
	
	public func parent() -> StorageReference? {
		guard let parent = platformValue.parent else { return nil }
		return StorageReference(parent)
	}
	
	public func child(_ path: String) -> StorageReference {
		return StorageReference(platformValue.child(path))
	}
	
	public func downloadURL() async throws -> URL {
		// SKIP NOWARN
		let uri: android.net.Uri = try await platformValue.downloadUrl.await()
		return URL(string: uri.toString())!
	}
}

#endif
