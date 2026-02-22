// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if canImport(FirebaseRemoteConfig)
@_exported import FirebaseRemoteConfig
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

public final class RemoteConfig {
    public let remoteconfig: com.google.firebase.remoteconfig.FirebaseRemoteConfig

    public init(remoteconfig: com.google.firebase.remoteconfig.FirebaseRemoteConfig) {
        self.remoteconfig = remoteconfig
    }

    public static func remoteConfig() -> RemoteConfig {
        RemoteConfig(remoteconfig: com.google.firebase.remoteconfig.FirebaseRemoteConfig.getInstance())
    }

    public static func remoteConfig(app: FirebaseApp) -> RemoteConfig {
        RemoteConfig(remoteconfig: com.google.firebase.remoteconfig.FirebaseRemoteConfig.getInstance(app.app))
    }
}
#endif
#endif
