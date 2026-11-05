// Copyright 2024–2026 Skip
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
#else
import SkipFirebaseCore
#endif

let logger: Logger = Logger(subsystem: "SkipBase", category: "Tests")

@MainActor final class SkipFirebaseCoreTests: XCTestCase {
    func testSkipFirebase() {
    }
}

