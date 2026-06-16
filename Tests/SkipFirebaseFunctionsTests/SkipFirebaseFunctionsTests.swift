// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
@preconcurrency import FirebaseFunctions
#else
import SkipFirebaseCore
import SkipFirebaseFunctions
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseFunctionsTests", category: "Tests")

@MainActor final class SkipFirebaseFunctionsTests: XCTestCase {
    func testSkipFirebaseFunctionsTests() async throws {
        if false {
            let _: Functions = Functions.functions()
            let _: Functions = Functions.functions(region: "europe-west4")

            let options = HTTPSCallableOptions(requireLimitedUseAppCheckTokens: true)
            let _: Bool = options.requireLimitedUseAppCheckTokens

            let functions = Functions.functions()
            let callable: HTTPSCallable = functions.httpsCallable("myFunc")
            let callableWithOptions: HTTPSCallable = functions.httpsCallable("myFunc", options: options)
            let urlCallable: HTTPSCallable = functions.httpsCallable(URL(string: "https://example.com/myFunc")!)
            let urlCallableWithOptions: HTTPSCallable = functions.httpsCallable(URL(string: "https://example.com/myFunc")!, options: options)

            callable.timeoutInterval = 30.0
            let _: TimeInterval = callable.timeoutInterval

            let result: HTTPSCallableResult = try await callable.call()
            let resultWithData: HTTPSCallableResult = try await callable.call(["key": "value"])
            let _: Any = result.data
            let _: HTTPSCallable = callableWithOptions
            let _: HTTPSCallable = urlCallable
            let _: HTTPSCallable = urlCallableWithOptions
            let _: HTTPSCallableResult = resultWithData
        }
    }
}

