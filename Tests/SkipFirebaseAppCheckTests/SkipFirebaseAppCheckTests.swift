// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

