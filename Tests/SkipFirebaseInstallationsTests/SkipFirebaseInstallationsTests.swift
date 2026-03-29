// SPDX-License-Identifier: MPL-2.0
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

@MainActor final class SkipFirebaseInstallationsTests: XCTestCase {
    func testSkipFirebaseInstallationsTests() async throws {
        if false {
            let _: Installations = Installations.installations()
        }
    }
}

