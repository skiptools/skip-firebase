// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAuth
#else
import SkipFirebaseCore
import SkipFirebaseAuth
#endif

let logger: Logger = Logger(subsystem: "SkipBase", category: "Tests")

final class SkipFirebaseAuthTests: XCTestCase {
    func testSkipFirebaseAuthTests() async throws {
        if false {
            let _: Auth = Auth.auth()
            let _: Auth = Auth.auth(app: FirebaseApp.app()!)
        }
    }
}

