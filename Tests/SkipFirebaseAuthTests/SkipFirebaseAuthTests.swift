// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAuth
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

    func testGetIDToken() async throws {
        let auth = Auth.auth()
        
        // First sign in anonymously to get a user
        let signInResult = try await auth.signInAnonymously()
        let user = signInResult.user
        
        // Test getting the token
        let token = try await user.getIDToken()
        XCTAssertFalse(token.isEmpty, "ID token should not be empty")
        
        // Test force refresh
        let refreshedToken = try await user.getIDToken(forceRefresh: true)
        XCTAssertFalse(refreshedToken.isEmpty, "Refreshed ID token should not be empty")
        
        // Clean up
        try await user.delete()
    }
}

