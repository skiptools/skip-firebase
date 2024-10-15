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

    public func reference(for url: URL) throws -> StorageReference {
        let storageReference = try platformValue.getReferenceFromUrl(url.absoluteString)
        return StorageReference(storageReference)
    }

    public func reference(withPath path: String) -> StorageReference {
      let storageReference = platformValue.getReference(path)
      return StorageReference(storageReference)
    }

    public func useEmulator(withHost host: String, port: Int) {
      platformValue.useEmulator(host, port)
   	}
}

public class StorageMetadata: KotlinConverting<com.google.firebase.storage.StorageMetadata> {

    public let platformValue: com.google.firebase.storage.StorageMetadata

    public init(platformValue: com.google.firebase.storage.StorageMetadata) {
        self.platformValue = platformValue
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.storage.StorageMetadata {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    public var bucket: String {
        return platformValue.getBucket()!
    }

    public var cacheControl: String? {
        return platformValue.getCacheControl()
    }

    public var contentDisposition: String? {
        return platformValue.getContentDisposition()
    }

    public var contentEncoding: String? {
        return platformValue.getContentEncoding()
    }

    public var contentLanguage: String? {
        return platformValue.getContentLanguage()
    }

    public var contentType: String? {
        return platformValue.getContentType()
    }

    public var md5Hash: String? {
        return platformValue.getMd5Hash()
    }

    public var generation: Int64 {
        return Int64(platformValue.getGeneration()!)!
    }

    public var customMetadata: [String : String]? {
        let metadataKeys = platformValue.getCustomMetadataKeys()
        guard !metadataKeys.isEmpty() else {
            return nil
        }
        var metadata: [String : String] = [:]
        for key in metadataKeys {
            if let metadataValue = platformValue.getCustomMetadata(key) {
                metadata[key] = metadataValue
            }
        }
        return metadata
    }

    public var metageneration: Int64 {
        return Int64(platformValue.getMetadataGeneration()!)!
    }

    public var name: String? {
        return platformValue.getName()
    }

    public var path: String? {
        return platformValue.getPath()
    }

    public var size: Int64 {
        return Int64(platformValue.getSizeBytes())
    }

    public var timeCreated: Date? {
        let platformDate: java.util.Date = java.util.Date(platformValue.getCreationTimeMillis())
        return Date(platformValue: platformDate)
    }

    public var updated: Date? {
        let platformDate: java.util.Date = java.util.Date(platformValue.getUpdatedTimeMillis())
        return Date(platformValue: platformDate)
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
        let uri: android.net.Uri = platformValue.downloadUrl.await()
        return URL(string: uri.toString())!
    }

    public func getData(maxSize: Int64) async throws -> Data {
        let data: kotlin.ByteArray = platformValue.getBytes(maxSize).await()
        return Data(platformValue: data)
    }

    public func putFile(from fileURL: URL, metadata: StorageMetadata? = nil, completion: (_: StorageMetadata?, _: Error?) -> Void) {
      let fileURI: android.net.Uri = android.net.Uri.parse(fileURL.kotlin().toString());

      let uploadTask = platformValue.putFile(fileURI, metadata?.platformValue, nil)
        uploadTask.addOnFailureListener { exception in
            completion(nil, ErrorException(exception))
        }.addOnSuccessListener { taskSnapshot in
          if let metadata = taskSnapshot.metadata {
            completion(StorageMetadata(platformValue: metadata), nil)
          } else {
            completion(nil, nil)
          }
        }
    }

    // TODO: Support onProgress once SKIP has support for Progress
    public func putFileAsync(from url: URL, metadata: StorageMetadata? = nil) async throws -> StorageMetadata {
        return try await withCheckedThrowingContinuation { continuation in
          putFile(from: url, metadata: metadata) { metadata, error in
            if let error {
              continuation.resume(throwing: error)
              return
            }
        
            continuation.resume(returning: metadata!)
          }
        }
    }

    public func delete(completion: (((any Error)?) -> Void)?) {
      Task {
        do {
          platformValue.delete().await()
          completion?(nil)
        } catch {
          completion?(error)
        }
      }
    }

    public func delete() async throws {
        platformValue.delete().await()
    }
}

#endif
