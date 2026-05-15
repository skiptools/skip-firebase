// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseInstallations)
@_exported import FirebaseInstallations
#elseif SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

public final class InstallationsAuthTokenResult {
    public let platformValue: com.google.firebase.installations.InstallationTokenResult

    public init(platformValue: com.google.firebase.installations.InstallationTokenResult) {
        self.platformValue = platformValue
    }

    public var authToken: String {
        platformValue.token
    }

    public var expirationDate: Date {
        // tokenExpirationTimestamp is Unix time in seconds
        Date(timeIntervalSince1970: Double(platformValue.tokenExpirationTimestamp))
    }
}

public final class Installations {
    public let installations: com.google.firebase.installations.FirebaseInstallations

    public init(installations: com.google.firebase.installations.FirebaseInstallations) {
        self.installations = installations
    }

    public static func installations() -> Installations {
        Installations(installations: com.google.firebase.installations.FirebaseInstallations.getInstance())
    }

    public static func installations(app: FirebaseApp) -> Installations {
        Installations(installations: com.google.firebase.installations.FirebaseInstallations.getInstance(app.app))
    }

    public func installationID() async throws -> String {
        try await self.installations.getId().await()
    }

    public func authToken() async throws -> InstallationsAuthTokenResult {
        InstallationsAuthTokenResult(platformValue: try await self.installations.getToken(false).await())
    }

    public func authTokenForcingRefresh(_ forceRefresh: Bool) async throws -> InstallationsAuthTokenResult {
        InstallationsAuthTokenResult(platformValue: try await self.installations.getToken(forceRefresh).await())
    }

    public func delete() async throws {
        try await self.installations.delete().await()
    }
}
#endif
#endif
