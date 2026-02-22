// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
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
}
#endif
#endif
