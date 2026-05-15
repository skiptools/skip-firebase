// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
#if canImport(FirebasePerformance)
import FirebasePerformance
#endif
#else
import SkipFirebaseCore
import SkipFirebasePerformance
#endif

let logger: Logger = Logger(subsystem: "SkipFirebasePerformanceTests", category: "Tests")

@MainActor final class SkipFirebasePerformanceTests: XCTestCase {
    func testSkipFirebasePerformanceTests() async throws {
        #if canImport(FirebasePerformance) || SKIP
        if false {
            let _: Performance = Performance.sharedInstance()
            let _: Trace? = Performance.sharedInstance().trace(name: "test_trace")
            let _: HTTPMetric? = HTTPMetric(url: URL(string: "https://example.com")!, httpMethod: .get)
        }
        #endif
    }
}
