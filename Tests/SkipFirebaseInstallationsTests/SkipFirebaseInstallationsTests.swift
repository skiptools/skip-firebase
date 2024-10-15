// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseInstallations
#else
import SkipFirebaseCore
import SkipFirebaseInstallations
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseInstallationsTests", category: "Tests")

final class SkipFirebaseInstallationsTests: XCTestCase {
    func testSkipFirebaseInstallationsTests() async throws {
        if false {
            let _: Installations = Installations.installations()
        }
    }
}

