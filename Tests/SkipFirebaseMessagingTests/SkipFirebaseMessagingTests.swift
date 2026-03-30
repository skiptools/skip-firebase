// Copyright 2024–2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseMessaging
#else
import SkipFirebaseCore
import SkipFirebaseMessaging
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseMessagingTests", category: "Tests")

@MainActor final class SkipFirebaseMessagingTests: XCTestCase {
    func testSkipFirebaseMessagingTests() async throws {
        if false {
            let messaging: Messaging = Messaging.messaging()
            try await messaging.subscribe(toTopic: "someTopic")
            try await messaging.unsubscribe(fromTopic: "someTopic")
        }
    }
}

