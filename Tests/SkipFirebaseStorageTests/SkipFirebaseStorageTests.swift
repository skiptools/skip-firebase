// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation

#if !SKIP
import FirebaseCore
import FirebaseStorage
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
        }
    }
}

