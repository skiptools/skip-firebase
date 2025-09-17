// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import Foundation
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

    public static func storage(url: String) -> Storage {
        Storage(com.google.firebase.storage.FirebaseStorage.getInstance(url))
    }

    public static func storage(app: FirebaseApp, url: String) -> Storage {
        Storage(com.google.firebase.storage.FirebaseStorage.getInstance(app.app, url))
    }

    public var app: FirebaseApp {
        FirebaseApp(app: platformValue.getApp())
    }

    public func reference() -> StorageReference {
        return StorageReference(platformValue.reference)
    }

    /// Throws `StorageException`
    public func reference(for url: URL) throws -> StorageReference {
        try reference(forURL: url.absoluteString)
    }

    /// Throws `StorageException`
    public func reference(forURL urlString: String) throws -> StorageReference {
        StorageReference(try platformValue.getReferenceFromUrl(urlString))
    }

    public func reference(withPath path: String) -> StorageReference {
        StorageReference(platformValue.getReference(path))
    }

    public func useEmulator(withHost host: String, port: Int) {
        platformValue.useEmulator(host, port)
    }
}

public class StorageMetadata: KotlinConverting<com.google.firebase.storage.StorageMetadata> {
    public var platformValue: com.google.firebase.storage.StorageMetadata

    public init() {
        self.platformValue = com.google.firebase.storage.StorageMetadata()
    }

    public init(platformValue: com.google.firebase.storage.StorageMetadata) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.storage.StorageMetadata {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    /// A builder for mutating the current underlying metadata
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/storage/StorageMetadata.Builder
    private var builder: com.google.firebase.storage.StorageMetadata.Builder {
        com.google.firebase.storage.StorageMetadata.Builder(self.platformValue)
    }

    public var bucket: String {
        return platformValue.getBucket()!
    }

    public var cacheControl: String? {
        get { platformValue.getCacheControl() }
        set { platformValue = builder.setCacheControl(newValue).build() }
    }

    public var contentDisposition: String? {
        get { platformValue.getContentDisposition() }
        set { platformValue = builder.setContentDisposition(newValue).build() }
    }

    public var contentEncoding: String? {
        get { platformValue.getContentEncoding() }
        set { platformValue = builder.setContentEncoding(newValue).build() }
    }

    public var contentLanguage: String? {
        get { platformValue.getContentLanguage() }
        set { platformValue = builder.setContentLanguage(newValue).build() }
    }

    public var contentType: String? {
        get { platformValue.getContentType() }
        set { platformValue = builder.setContentType(newValue).build() }
    }

    public var md5Hash: String? {
        return platformValue.getMd5Hash()
    }

    public var generation: Int64 {
        return Int64(platformValue.getGeneration()!)!
    }

    public var customMetadata: [String : String]? {
        get {
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

        set {
            // FIXME: this differs from the iOS API in that it will not clean any unused existing custom metadata key/values from the previous metadata; we would need to create and populate a fresh StorageMetadata.Builder rather than basing it on the existing metadata to do that
            let b = self.builder
            if let newValue {
                for (key, value) in newValue {
                    b.setCustomMetadata(key, value)
                }
            }
            self.platformValue = b.build()
        }
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

    // SKIP @nooverride
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

    /// Throws `StorageException`
    public func downloadURL() async throws -> URL {
        let uri: android.net.Uri = platformValue.downloadUrl.await()
        return URL(string: uri.toString())!
    }

    /// Throws `StorageException`
    public func getMetadata() async throws -> StorageMetadata {
        let metadata = platformValue.getMetadata().await()
        return StorageMetadata(platformValue: metadata)
    }

    /// Throws `StorageException`
    public func updateMetadata(_ metadata: StorageMetadata) async throws -> StorageMetadata {
        let metadata = platformValue.updateMetadata(metadata.platformValue).await()
        return StorageMetadata(platformValue: metadata)
    }

    /// Error is `StorageException`
    public func putFile(from fileURL: URL, metadata: StorageMetadata? = nil, completion: @escaping (_: StorageMetadata?, _: Error?) -> Void = { _, _ in }) -> StorageUploadTask {
        let fileURI: android.net.Uri = android.net.Uri.parse(fileURL.kotlin().toString())

        let uploadTask = metadata == nil ? platformValue.putFile(fileURI) : platformValue.putFile(fileURI, metadata!.platformValue, nil)
        uploadTask.addOnFailureListener { exception in
            completion(nil, ErrorException(exception))
        }.addOnSuccessListener { taskSnapshot in
            if let metadata = taskSnapshot.metadata {
                completion(StorageMetadata(platformValue: metadata), nil)
            } else {
                completion(nil, nil)
            }
        }

        return StorageUploadTask(platformValue: uploadTask)
    }

    // TODO: Support onProgress once SKIP has support for Progress
    /// Error is `StorageException`
    public func putFileAsync(from url: URL, metadata: StorageMetadata? = nil) async throws -> StorageMetadata {
        return try await withCheckedThrowingContinuation { continuation in
            putFile(from: url, metadata: metadata) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: metadata!)
                }
            }
        }
    }

    /// Error is `StorageException`
    public func putData(_ uploadData: Data, metadata: StorageMetadata? = nil, completion: @escaping (_: StorageMetadata?, _: Error?) -> Void) -> StorageUploadTask {
        // putBytes(bytes, metadata) is @NonNull, so we need to use different methods for null vs. non-null metadata parameter
        let uploadTask = metadata == nil ? platformValue.putBytes(uploadData.platformValue) : platformValue.putBytes(uploadData.platformValue, metadata!.platformValue)

        uploadTask.addOnFailureListener { exception in
            completion(nil, ErrorException(exception))
        }.addOnSuccessListener { taskSnapshot in
            if let metadata = taskSnapshot.metadata {
                completion(StorageMetadata(platformValue: metadata), nil)
            } else {
                completion(nil, nil)
            }
        }

        return StorageUploadTask(platformValue: uploadTask)
    }

    // TODO: Support onProgress once SKIP has support for Progress
    /// Throws `StorageException`
    public func putDataAsync(_ uploadData: Data, metadata: StorageMetadata? = nil) async throws -> StorageMetadata {
        return try await withCheckedThrowingContinuation { continuation in
            putData(uploadData, metadata: metadata) { metadata, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: metadata!)
                }
            }
        }
    }

    /// Error is `StorageException`
    public func write(toFile fileURL: URL, completion: ((_: URL?, _: Error?) -> Void)? = nil) -> StorageDownloadTask {
        let fileURI: android.net.Uri = android.net.Uri.parse(fileURL.kotlin().toString())
        let downloadTask = platformValue.getFile(fileURI)

        downloadTask.addOnFailureListener { exception in
            completion?(nil, ErrorException(exception))
        }.addOnSuccessListener { (taskSnapshot: com.google.firebase.storage.FileDownloadTask.TaskSnapshot) in
            completion?(fileURL, nil)
        }

        return StorageFileDownloadTask(platformValue: downloadTask)
    }

    /// Async version of getData(), but note that the iOS Firestore does not have an equivalent for some reason
    /// Throws `StorageException`/`IndexOutOfBoundsException`
    public func getDataAsync(maxSize: Int64) async throws -> Data {
        let data: kotlin.ByteArray = platformValue.getBytes(maxSize).await()
        return Data(platformValue: data)
    }

    /// Error is `StorageException`/`IndexOutOfBoundsException`
    public func getData(maxSize: Int64, completion: @escaping (_: Data?, _: Error?) -> Void) -> StorageDownloadTask {

        let downloadTask = platformValue.getBytes(maxSize)
        Task {
            do {
                let data: kotlin.ByteArray = downloadTask.await()
                completion(Data(platformValue: data), nil)
            } catch {
                completion(nil, error)
            }
        }
        return StoragBytesDownloadTask(platformValue: downloadTask)
    }

    /// Error is `StorageException`
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

public class StorageTask {
    init() {
    }
}

public protocol StorageTaskManagement {
    func pause() -> Void
    func cancel() -> Void
    func resume() -> Void
}

public class StorageObservableTask : StorageTask {
    override init() {
        super.init()
    }
}

public final class StorageUploadTask : StorageTaskManagement {
    public let platformValue: com.google.firebase.storage.UploadTask

    init(platformValue: com.google.firebase.storage.UploadTask) {
        super.init()
        self.platformValue = platformValue
    }

    public func cancel() {
        platformValue.cancel()
        return
    }

    public func pause() {
        platformValue.pause()
        return
    }

    public func resume() {
        platformValue.resume()
        return
    }
}

public class StorageDownloadTask {
}

public final class StoragBytesDownloadTask : StorageDownloadTask {
    public let platformValue: com.google.android.gms.tasks.Task<kotlin.ByteArray!>

    init(platformValue: com.google.android.gms.tasks.Task<kotlin.ByteArray!>) {
        self.platformValue = platformValue
    }
}

public final class StorageFileDownloadTask : StorageDownloadTask, StorageTaskManagement {
    public let platformValue: com.google.firebase.storage.FileDownloadTask

    init(platformValue: com.google.firebase.storage.FileDownloadTask) {
        super.init()
        self.platformValue = platformValue
    }

    public func cancel() {
        platformValue.cancel()
        return
    }

    public func pause() {
        platformValue.pause()
        return
    }

    public func resume() {
        platformValue.resume()
        return
    }
}

#endif
#endif
