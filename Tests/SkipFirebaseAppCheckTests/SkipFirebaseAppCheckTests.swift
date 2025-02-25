// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAppCheck
#else
import SkipFirebaseCore
import SkipFirebaseAppCheck
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseAppCheckTests", category: "Tests")

@MainActor final class SkipFirebaseAppCheckTests: XCTestCase {
    func testSkipFirebaseAppCheckTests() async throws {
        if false {
            let _: AppCheck = AppCheck.appCheck()
        }
    }
}

