// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
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

