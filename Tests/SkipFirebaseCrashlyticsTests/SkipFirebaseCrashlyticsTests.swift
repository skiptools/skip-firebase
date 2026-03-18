// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseCrashlytics
#else
import SkipFirebaseCore
import SkipFirebaseCrashlytics
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseCrashlyticsTests", category: "Tests")

@MainActor final class SkipFirebaseCrashlyticsTests: XCTestCase {
    func testSkipFirebaseCrashlyticsTests() async throws {
        if false {
            let _: Crashlytics = Crashlytics.crashlytics()
        }
    }
}

