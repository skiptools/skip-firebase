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
            let rc: RemoteConfig = RemoteConfig.remoteConfig()

            // Fetch & Activate
            let _: RemoteConfigFetchAndActivateStatus = try await rc.fetchAndActivate()
            let _: Bool = try await rc.activate()
            let _: RemoteConfigFetchStatus = try await rc.fetch()
            let _: RemoteConfigFetchStatus = try await rc.fetch(withExpirationDuration: 3600)
            try await rc.ensureInitialized()

            // Get values via subscript and configValue
            let _: RemoteConfigValue = rc.configValue(forKey: "key")
            let _: RemoteConfigValue = rc.configValue(forKey: "key", source: .remote)
            let _: [String] = rc.allKeys(from: .remote)
            let _: Set<String> = rc.keys(withPrefix: "")
            let _: RemoteConfigValue? = rc.defaultValue(forKey: "key")

            // Info
            let _: RemoteConfigFetchStatus = rc.lastFetchStatus
            let _: Date? = rc.lastFetchTime

            // Settings
            var settings = RemoteConfigSettings()
            settings.minimumFetchInterval = 3600
            settings.fetchTimeout = 30
            let _: TimeInterval = settings.minimumFetchInterval
            let _: TimeInterval = settings.fetchTimeout
            rc.configSettings = settings

            // Defaults
            rc.setDefaults(["key": "value" as NSObject])

            // RemoteConfigValue properties
            let val: RemoteConfigValue = rc.configValue(forKey: "key")
            let _: String = val.stringValue
            let _: Bool = val.boolValue
            let _ = val.numberValue
            let _: Data = val.dataValue
            let _: RemoteConfigSource = val.source
        }
    }
}
