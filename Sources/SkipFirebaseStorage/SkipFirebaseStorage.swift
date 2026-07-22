// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseStorage)
@_exported import FirebaseStorage
#elseif SKIP
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

    /// Maximum time in seconds to retry an upload if a failure occurs.
    /// Defaults to 10 minutes (600 seconds).
    public var maxUploadRetryTime: TimeInterval {
        get { TimeInterval(platformValue.getMaxUploadRetryTimeMillis()) / 1000.0 }
        set { platformValue.setMaxUploadRetryTimeMillis(Int64(newValue * 1000.0)) }
    }

    /// Maximum time in seconds to retry a download if a failure occurs.
    /// Defaults to 10 minutes (600 seconds).
    public var maxDownloadRetryTime: TimeInterval {
        get { TimeInterval(platformValue.getMaxDownloadRetryTimeMillis()) / 1000.0 }
        set { platformValue.setMaxDownloadRetryTimeMillis(Int64(newValue * 1000.0)) }
    }

    /// Maximum time in seconds to retry operations other than upload and download if a failure occurs.
    /// Defaults to 2 minutes (120 seconds).
    public var maxOperationRetryTime: TimeInterval {
        get { TimeInterval(platformValue.getMaxOperationRetryTimeMillis()) / 1000.0 }
        set { platformValue.setMaxOperationRetryTimeMillis(Int64(newValue * 1000.0)) }
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

    /// Throws `StorageException`
    public func list(maxResults: Int64) async throws -> StorageListResult {
        let clamped = Int(max(min(maxResults, Int64(Int.max)), Int64(Int.min)))
        let result: com.google.firebase.storage.ListResult = platformValue.list(clamped).await()
        return StorageListResult(platformValue: result)
    }

    /// Throws `StorageException`
    public func list(maxResults: Int64, pageToken: String) async throws -> StorageListResult {
        let clamped = Int(max(min(maxResults, Int64(Int.max)), Int64(Int.min)))
        let result: com.google.firebase.storage.ListResult = platformValue.list(clamped, pageToken).await()
        return StorageListResult(platformValue: result)
    }

    /// Throws `StorageException`
    public func listAll() async throws -> StorageListResult {
        let result: com.google.firebase.storage.ListResult = platformValue.listAll().await()
        return StorageListResult(platformValue: result)
    }
}

public class StorageListResult {
    public let platformValue: com.google.firebase.storage.ListResult

    public init(platformValue: com.google.firebase.storage.ListResult) {
        self.platformValue = platformValue
    }

    public var items: [StorageReference] {
        var refs: [StorageReference] = []
        for item in platformValue.items {
            refs.append(StorageReference(platformValue: item))
        }
        return refs
    }

    public var prefixes: [StorageReference] {
        var refs: [StorageReference] = []
        for prefix in platformValue.prefixes {
            refs.append(StorageReference(platformValue: prefix))
        }
        return refs
    }

    public var pageToken: String? {
        platformValue.pageToken
    }
}

public enum StorageTaskStatus: Int {
    case unknown = 0
    case resume = 1
    case progress = 2
    case pause = 3
    case success = 4
    case failure = 5
}

/// Byte-level progress for a storage transfer, mirroring the fields of `Foundation.Progress`
/// that are relevant to Firebase Storage operations.
public struct StorageProgress {
    public let completedUnitCount: Int64
    public let totalUnitCount: Int64

    public var fractionCompleted: Double {
        guard totalUnitCount > 0 else { return 0 }
        return Double(completedUnitCount) / Double(totalUnitCount)
    }
}

public class StorageTaskSnapshot {
    public let status: StorageTaskStatus
    public var progress: StorageProgress?
    public var metadata: StorageMetadata?
    public var error: Error?

    init(status: StorageTaskStatus, progress: StorageProgress? = nil, metadata: StorageMetadata? = nil, error: Error? = nil) {
        self.status = status
        self.progress = progress
        self.metadata = metadata
        self.error = error
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
    private var activeObservers: [String: Bool] = [:]

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

    @discardableResult
    public func observe(_ status: StorageTaskStatus, handler: @escaping (StorageTaskSnapshot) -> Void) -> String {
        let handle = UUID().uuidString
        activeObservers[handle] = true

        switch status {
        case .progress:
            platformValue.addOnProgressListener { taskSnapshot in
                guard self.activeObservers[handle] == true else { return }
                let p = StorageProgress(completedUnitCount: taskSnapshot.bytesTransferred, totalUnitCount: taskSnapshot.totalByteCount)
                handler(StorageTaskSnapshot(status: .progress, progress: p))
            }
        case .success:
            platformValue.addOnSuccessListener { taskSnapshot in
                guard self.activeObservers[handle] == true else { return }
                var metadata: StorageMetadata? = nil
                if let m = taskSnapshot.metadata {
                    metadata = StorageMetadata(platformValue: m)
                }
                handler(StorageTaskSnapshot(status: .success, metadata: metadata))
            }
        case .failure:
            platformValue.addOnFailureListener { exception in
                guard self.activeObservers[handle] == true else { return }
                handler(StorageTaskSnapshot(status: .failure, error: ErrorException(exception)))
            }
        case .pause:
            platformValue.addOnPausedListener { _ in
                guard self.activeObservers[handle] == true else { return }
                handler(StorageTaskSnapshot(status: .pause))
            }
        default:
            break
        }

        return handle
    }

    public func removeObserver(withHandle handle: String) {
        activeObservers[handle] = false
    }

    public func removeAllObservers() {
        for key in activeObservers.keys {
            activeObservers[key] = false
        }
    }

    public func removeAllObservers(for status: StorageTaskStatus) {
        removeAllObservers()
    }
}

public class StorageDownloadTask {
    @discardableResult
    open func observe(_ status: StorageTaskStatus, handler: @escaping (StorageTaskSnapshot) -> Void) -> String {
        return ""
    }

    open func removeObserver(withHandle handle: String) { }
    open func removeAllObservers() { }
    open func removeAllObservers(for status: StorageTaskStatus) { }
}

public final class StoragBytesDownloadTask : StorageDownloadTask {
    public let platformValue: com.google.android.gms.tasks.Task<kotlin.ByteArray!>

    init(platformValue: com.google.android.gms.tasks.Task<kotlin.ByteArray!>) {
        self.platformValue = platformValue
    }
}

public class StorageFileDownloadTask : StorageDownloadTask, StorageTaskManagement {
    public let platformValue: com.google.firebase.storage.FileDownloadTask
    private var activeObservers: [String: Bool] = [:]

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

    @discardableResult
    override public func observe(_ status: StorageTaskStatus, handler: @escaping (StorageTaskSnapshot) -> Void) -> String {
        let handle = UUID().uuidString
        activeObservers[handle] = true

        switch status {
        case .progress:
            platformValue.addOnProgressListener { taskSnapshot in
                guard self.activeObservers[handle] == true else { return }
                let p = StorageProgress(completedUnitCount: taskSnapshot.bytesTransferred, totalUnitCount: taskSnapshot.totalByteCount)
                handler(StorageTaskSnapshot(status: .progress, progress: p))
            }
        case .success:
            platformValue.addOnSuccessListener { (taskSnapshot: com.google.firebase.storage.FileDownloadTask.TaskSnapshot) in
                guard self.activeObservers[handle] == true else { return }
                handler(StorageTaskSnapshot(status: .success))
            }
        case .failure:
            platformValue.addOnFailureListener { exception in
                guard self.activeObservers[handle] == true else { return }
                handler(StorageTaskSnapshot(status: .failure, error: ErrorException(exception)))
            }
        case .pause:
            platformValue.addOnPausedListener { _ in
                guard self.activeObservers[handle] == true else { return }
                handler(StorageTaskSnapshot(status: .pause))
            }
        default:
            break
        }

        return handle
    }

    override public func removeObserver(withHandle handle: String) {
        activeObservers[handle] = false
    }

    override public func removeAllObservers() {
        for key in activeObservers.keys {
            activeObservers[key] = false
        }
    }

    override public func removeAllObservers(for status: StorageTaskStatus) {
        removeAllObservers()
    }
}

#endif
#endif
