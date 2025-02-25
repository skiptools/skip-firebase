// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAnalytics
#else
import SkipFirebaseCore
import SkipFirebaseAnalytics
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseAnalyticsTests", category: "Tests")

@MainActor final class SkipFirebaseAnalyticsTests: XCTestCase {
    func testSkipFirebaseAnalyticsTests() async throws {
        Analytics.logEvent("x", parameters: ["a": [1, 2, false]])
    }
}

