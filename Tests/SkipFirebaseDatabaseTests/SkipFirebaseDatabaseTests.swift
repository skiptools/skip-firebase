// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

