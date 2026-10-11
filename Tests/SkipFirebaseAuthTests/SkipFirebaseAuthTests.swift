// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
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
                // Shape parity with iOS FirebaseAuth: `providerData` is a list of
                // `UserInfo` carrying `providerID`, and the pre-change email
                // verification takes the new address.
                let providers: [String] = signIn.user.providerData.map { $0.providerID }
                XCTAssertNotNil(providers)
                try await signIn.user.sendEmailVerification(beforeUpdatingEmail: "new@example.org")
            } catch {
            }
            auth.removeStateDidChangeListener(listener)
        }
    }

    /// Runs for real on both platforms: building a Google credential needs no network
    /// and no Firebase app, so the assertion is an actual check rather than a shape test.
    func testGoogleAuthProviderCredential() throws {
        XCTAssertEqual("google.com", GoogleAuthProvider.id)

        let credential = GoogleAuthProvider.credential(withIDToken: "test-id-token", accessToken: "test-access-token")
        XCTAssertEqual("google.com", credential.provider)

        // Credential Manager hands out an ID token without an access token, so the
        // empty-access-token case has to build the same kind of credential.
        let idTokenOnly = GoogleAuthProvider.credential(withIDToken: "test-id-token", accessToken: "")
        XCTAssertEqual("google.com", idTokenOnly.provider)
    }
}

