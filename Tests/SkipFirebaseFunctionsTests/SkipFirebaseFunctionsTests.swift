// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

@MainActor final class SkipFirebaseFunctionsTests: XCTestCase {
    func testSkipFirebaseFunctionsTests() async throws {
        if false {
            let _: Functions = Functions.functions()
        }
    }
}

