// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseInstallations)
@_exported import FirebaseInstallations
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

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
}
#endif
#endif
