// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
#else
import SkipFirebaseCore
#endif

let logger: Logger = Logger(subsystem: "SkipBase", category: "Tests")

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class SkipFirebaseCoreTests: XCTestCase {
    func testSkipFirebase() {
    }
}

