// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseFunctions
#else
import SkipFirebaseCore
import SkipFirebaseFunctions
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseFunctionsTests", category: "Tests")

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
@MainActor final class SkipFirebaseFunctionsTests: XCTestCase {
    func testSkipFirebaseFunctionsTests() async throws {
        if false {
            let _: Functions = Functions.functions()
        }
    }
}

