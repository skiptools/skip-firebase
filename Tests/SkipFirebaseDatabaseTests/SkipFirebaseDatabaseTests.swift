// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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

