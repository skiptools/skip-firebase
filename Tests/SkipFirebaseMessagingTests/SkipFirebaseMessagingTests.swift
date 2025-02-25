// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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

