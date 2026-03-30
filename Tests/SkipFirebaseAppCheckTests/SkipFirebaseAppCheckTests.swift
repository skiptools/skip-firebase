// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAppCheck
#else
import SkipFirebaseCore
import SkipFirebaseAppCheck
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseAppCheckTests", category: "Tests")

@MainActor final class SkipFirebaseAppCheckTests: XCTestCase {
    func testSkipFirebaseAppCheckTests() async throws {
        if false {
            let appCheck: AppCheck = AppCheck.appCheck()
            //let _: AppCheck = AppCheck.appCheck(app: FirebaseApp.app()!)

            // Provider factory
            let debugFactory = AppCheckDebugProviderFactory()
            AppCheck.setAppCheckProviderFactory(debugFactory)

            // Token retrieval
            let token: AppCheckToken = try await appCheck.token(forcingRefresh: false)
            let _: String = token.token
            let _: Date = token.expirationDate

            // Limited-use token
            let limitedToken: AppCheckToken = try await appCheck.limitedUseToken()
            let _: String = limitedToken.token

            // Auto-refresh
            appCheck.isTokenAutoRefreshEnabled = true
            let _: Bool = appCheck.isTokenAutoRefreshEnabled
        }
    }
}

