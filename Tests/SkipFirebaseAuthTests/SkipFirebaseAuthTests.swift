// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
// @preconcurrency: Firebase's Objective-C types (e.g. AuthDataResult) are not audited for
// Sendable, so awaiting its async methods from this @MainActor test would be a hard error
// under Swift 6. Downgrade those to warnings for this pre-concurrency interop.
@preconcurrency import FirebaseAuth
#else
import SkipFirebaseCore
import SkipFirebaseAuth
#endif

let logger: Logger = Logger(subsystem: "SkipBase", category: "Tests")

@MainActor final class SkipFirebaseAuthTests: XCTestCase {
    func testSkipFirebaseAuthTests() async throws {
        if false {
            let auth: Auth = Auth.auth()
            let _: Auth = Auth.auth(app: FirebaseApp.app()!)
            let listener = auth.addStateDidChangeListener({ _, _ in })
            do {
                let signIn = try await auth.signInAnonymously()
                XCTAssertNotNil(signIn.user.metadata.creationDate)
                XCTAssertNotNil(signIn.user.metadata.lastSignInDate)
            } catch {
            }
            auth.removeStateDidChangeListener(listener)
        }
    }
}

