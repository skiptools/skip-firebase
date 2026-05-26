// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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
            let functions: Functions = Functions.functions()
            let callable: HTTPSCallable = functions.httpsCallable("noop")
            // Compile-check the async overload resolves (no live backend in CI).
            let _: HTTPSCallableResult = try await callable.call(["k": "v"])
            let _: HTTPSCallableResult = try await callable.call()
        }
    }
}

