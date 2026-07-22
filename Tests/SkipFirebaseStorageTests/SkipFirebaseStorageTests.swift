// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation

#if !SKIP
import FirebaseCore
@preconcurrency import FirebaseStorage
#else
import SkipFirebaseCore
import SkipFirebaseStorage
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseStorageTests", category: "Tests")

@MainActor final class SkipFirebaseStorageTests: XCTestCase {
    func testSkipFirebaseStorageTests() async throws {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        XCTAssertEqual(metadata.contentType, "image/jpeg")

        metadata.cacheControl = "max-age=3600"
        XCTAssertEqual(metadata.cacheControl, "max-age=3600")

        metadata.contentDisposition = "attachment; filename=test.jpg"
        XCTAssertEqual(metadata.contentDisposition, "attachment; filename=test.jpg")

        metadata.customMetadata = ["key": "value"]
        XCTAssertEqual(metadata.customMetadata, ["key": "value"])

        if false {
            let fileURL = URL(fileURLWithPath: "/dev/null")

            // we don't actually connect to the storage here, so we are just checking the API signatures for get/put data
            let storageCustomURL = Storage.storage(url: "gs://")

            let storage = Storage.storage()

            storage.maxUploadRetryTime = 60.0
            storage.maxDownloadRetryTime = 60.0
            storage.maxOperationRetryTime = 60.0
            let _: TimeInterval = storage.maxUploadRetryTime
            let _: TimeInterval = storage.maxDownloadRetryTime
            let _: TimeInterval = storage.maxOperationRetryTime

            let ref: StorageReference = storage.reference()
            let _: StorageReference = storage.reference(withPath: "test")
            let _: StorageReference = storage.reference(forURL: "https://firebase.google.com/")
            let _: StorageReference = try storage.reference(for: fileURL)

            let childRef: StorageReference = ref.child("test")
            let parentRef: StorageReference? = ref.parent()

            let path: String = ref.fullPath
            let name: String = ref.name

            let metadata: StorageMetadata = try await ref.getMetadata()
            let umd1: StorageMetadata = try await ref.updateMetadata(metadata)

            let umd2: StorageMetadata = try await ref.putDataAsync(Data())
            let sut: StorageUploadTask = ref.putData(Data()) { md, error in
            }

            sut.cancel()
            sut.pause()
            sut.resume()

            let pda1: StorageMetadata = try await ref.putDataAsync(Data(), metadata: metadata)

            let pfa1: StorageMetadata = try await ref.putFileAsync(from: fileURL)
            let pfa2: StorageMetadata = try await ref.putFileAsync(from: fileURL, metadata: metadata)

            let pfut1: StorageUploadTask = ref.putFile(from: fileURL, metadata: metadata)

            let sdt1: StorageDownloadTask = ref.getData(maxSize: 1024) { data, error in
            }

            let sdt2: StorageDownloadTask = ref.write(toFile: fileURL)
            let sdt3: StorageDownloadTask = ref.write(toFile: fileURL, completion: { url, error in
            })

            // list / listAll
            let listResult: StorageListResult = try await ref.listAll()
            let _: [StorageReference] = listResult.items
            let _: [StorageReference] = listResult.prefixes
            let _: String? = listResult.pageToken

            let pagedResult: StorageListResult = try await ref.list(maxResults: 10)
            let _: [StorageReference] = pagedResult.items
            let pagedResultWithToken: StorageListResult = try await ref.list(maxResults: 10, pageToken: "token")
            let _: [StorageReference] = pagedResultWithToken.items

            // progress observers — upload
            let handle1: String = sut.observe(.progress) { snapshot in
                let _: StorageTaskStatus = snapshot.status
                let _ = snapshot.progress
                let _: StorageMetadata? = snapshot.metadata
                let _: Error? = snapshot.error
            }
            let _: String = sut.observe(.success) { _ in }
            let _: String = sut.observe(.failure) { _ in }
            let _: String = sut.observe(.pause) { _ in }
            sut.removeObserver(withHandle: handle1)
            sut.removeAllObservers()
            sut.removeAllObservers(for: .progress)

            // progress observers — file download
            let handle2: String = sdt2.observe(.progress) { snapshot in
                let _ = snapshot.progress
            }
            let _: String = sdt2.observe(.success) { _ in }
            let _: String = sdt2.observe(.failure) { _ in }
            sdt2.removeObserver(withHandle: handle2)
            sdt2.removeAllObservers()
            sdt2.removeAllObservers(for: .progress)
        }
    }

    func testStorageListResultTypes() throws {
        #if SKIP
        // Validate that list/listAll and StorageListResult properties exist.
        // Async function references and typed closures cause Kotlin type-inference issues,
        // so we use named variables to preserve type context.
        let _items: (StorageListResult) -> [StorageReference] = { result in result.items }
        let _prefixes: (StorageListResult) -> [StorageReference] = { result in result.prefixes }
        let _pageToken: (StorageListResult) -> String? = { result in result.pageToken }
        #endif
    }

    func testStorageTaskObserverTypes() throws {
        #if SKIP
        // Validate StorageTaskStatus, StorageTaskSnapshot, and observer API types compile.
        // These are Skip-specific wrappers; the iOS SDK uses StorageTaskState/Progress instead.
        let _: StorageTaskStatus = StorageTaskStatus.progress
        let _: StorageTaskStatus = StorageTaskStatus.success
        let _: StorageTaskStatus = StorageTaskStatus.failure
        let _: StorageTaskStatus = StorageTaskStatus.pause
        let _: StorageTaskStatus = StorageTaskStatus.resume
        let _: StorageTaskStatus = StorageTaskStatus.unknown

        let snapshot = StorageTaskSnapshot(status: StorageTaskStatus.progress)
        let _: StorageTaskStatus = snapshot.status
        let _: StorageProgress? = snapshot.progress
        let _: StorageMetadata? = snapshot.metadata
        let _: Error? = snapshot.error
        #endif
    }
}

