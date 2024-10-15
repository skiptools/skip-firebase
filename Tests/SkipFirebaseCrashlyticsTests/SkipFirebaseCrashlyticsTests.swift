// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

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

final class SkipFirebaseCrashlyticsTests: XCTestCase {
    func testSkipFirebaseCrashlyticsTests() async throws {
        if false {
            let _: Crashlytics = Crashlytics.crashlytics()
        }
    }
}

