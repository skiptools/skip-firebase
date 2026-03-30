// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseDatabase
#else
import SkipFirebaseCore
import SkipFirebaseDatabase
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseDatabaseTests", category: "Tests")

@MainActor final class SkipFirebaseDatabaseTests: XCTestCase {
    func testSkipFirebaseDatabaseTests() async throws {
        if false {
            let _: Database = Database.database()
        }
    }
}

