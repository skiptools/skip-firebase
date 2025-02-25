// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseRemoteConfig
#else
import SkipFirebaseCore
import SkipFirebaseRemoteConfig
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseRemoteConfigTests", category: "Tests")

@MainActor final class SkipFirebaseRemoteConfigTests: XCTestCase {
    func testSkipFirebaseRemoteConfigTests() async throws {
        if false {
            let _: RemoteConfig = RemoteConfig.remoteConfig()
        }
    }
}

