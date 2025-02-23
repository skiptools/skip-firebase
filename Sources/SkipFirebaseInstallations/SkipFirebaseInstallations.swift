// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
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
