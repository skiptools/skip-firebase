// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfig
// https://firebase.google.com/docs/reference/android/com/google/firebase/remoteconfig/FirebaseRemoteConfig

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

    // MARK: - Fetch & Activate

    /// Fetches and activates configs in one call.
    /// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfig#fetchandactivate()
    public func fetchAndActivate() async throws -> RemoteConfigFetchAndActivateStatus {
        let activated = try await remoteconfig.fetchAndActivate().await() == true
        return activated ? .successFetchedFromRemote : .successUsingPreFetchedData
    }

    /// Activates the most recently fetched configs.
    public func activate() async throws -> Bool {
        try await remoteconfig.activate().await() == true
    }

    /// Fetches configs using the default minimum fetch interval.
    /// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfig#fetch()
    @discardableResult
    public func fetch() async throws -> RemoteConfigFetchStatus {
        try await remoteconfig.fetch().await()
        return .success
    }

    /// Fetches configs using the specified minimum fetch interval (seconds).
    /// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfig#fetchwithexpirationduration(_:)
    @discardableResult
    public func fetch(withExpirationDuration expirationDuration: TimeInterval) async throws -> RemoteConfigFetchStatus {
        try await remoteconfig.fetch(Int64(expirationDuration)).await()
        return .success
    }

    /// Ensures the Remote Config instance is initialized.
    public func ensureInitialized() async throws {
        try await remoteconfig.ensureInitialized().await()
    }

    // MARK: - Get values

    public func configValue(forKey key: String?) -> RemoteConfigValue {
        RemoteConfigValue(remoteconfig.getValue(key ?? ""))
    }

    public func configValue(forKey key: String?, source: RemoteConfigSource) -> RemoteConfigValue {
        // Android doesn't support per-source lookup directly; return active value
        RemoteConfigValue(remoteconfig.getValue(key ?? ""))
    }

    /// Returns all keys for a given source.
    public func allKeys(from source: RemoteConfigSource) -> [String] {
        var result: [String] = []
        for key in remoteconfig.getKeysByPrefix("") {
            result.append(key)
        }
        return result
    }

    /// Returns keys matching the given prefix. Pass nil or empty string for all keys.
    public func keys(withPrefix prefix: String?) -> Set<String> {
        var result = Set<String>()
        for key in remoteconfig.getKeysByPrefix(prefix ?? "") {
            result.insert(key)
        }
        return result
    }

    // MARK: - Info

    public var lastFetchStatus: RemoteConfigFetchStatus {
        switch remoteconfig.getInfo().getLastFetchStatus() {
        case com.google.firebase.remoteconfig.FirebaseRemoteConfig.LAST_FETCH_STATUS_SUCCESS:
            return .success
        case com.google.firebase.remoteconfig.FirebaseRemoteConfig.LAST_FETCH_STATUS_FAILURE:
            return .failure
        case com.google.firebase.remoteconfig.FirebaseRemoteConfig.LAST_FETCH_STATUS_THROTTLED:
            return .throttled
        default:
            return .noFetchYet
        }
    }

    public var lastFetchTime: Date? {
        let millis = remoteconfig.getInfo().getFetchTimeMillis()
        guard millis >= 0 else { return nil }
        return Date(timeIntervalSince1970: Double(millis) / 1000.0)
    }

    // MARK: - Settings

    public var configSettings: RemoteConfigSettings {
        get {
            RemoteConfigSettings(platformValue: remoteconfig.getInfo().getConfigSettings())
        }
        set {
            remoteconfig.setConfigSettingsAsync(newValue.platformValue)
        }
    }

    // MARK: - Defaults

    /// Sets config defaults synchronously (iOS API).
    public func setDefaults(_ defaults: [String: NSObject]?) {
        guard let defaults else { return }
        var map: [String: Any] = [:]
        for (k, v) in defaults { map[k] = v }
        remoteconfig.setDefaultsAsync(map as Map<String, Object>)
    }

    public func defaultValue(forKey key: String?) -> RemoteConfigValue? {
        guard let key else { return nil }
        return RemoteConfigValue(remoteconfig.getValue(key))
    }
}

// MARK: - RemoteConfigValue

public final class RemoteConfigValue {
    public let platformValue: com.google.firebase.remoteconfig.FirebaseRemoteConfigValue

    public init(_ platformValue: com.google.firebase.remoteconfig.FirebaseRemoteConfigValue) {
        self.platformValue = platformValue
    }

    /// Gets the value as a String.
    public var stringValue: String {
        platformValue.asString()
    }

    /// Gets the value as a Bool.
    public var boolValue: Bool {
        platformValue.asBoolean()
    }

    /// Gets the value as an NSNumber.
    public var numberValue: NSNumber {
        NSNumber(value: platformValue.asDouble())
    }

    /// Gets the value as Data.
    public var dataValue: Data {
        let bytes: kotlin.ByteArray = platformValue.asByteArray()
        return Data(platformValue: bytes)
    }

    /// Identifies the source of the fetched value.
    public var source: RemoteConfigSource {
        switch platformValue.getSource() {
        case com.google.firebase.remoteconfig.FirebaseRemoteConfig.VALUE_SOURCE_REMOTE:
            return .remote
        case com.google.firebase.remoteconfig.FirebaseRemoteConfig.VALUE_SOURCE_DEFAULT:
            return .default
        default:
            return .static
        }
    }
}

// MARK: - RemoteConfigSource
// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Enums/RemoteConfigSource

public enum RemoteConfigSource : Int {
    case remote = 0
    case `default` = 1
    case `static` = 2
}

// MARK: - RemoteConfigFetchStatus
// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Enums/RemoteConfigFetchStatus

public enum RemoteConfigFetchStatus : Int {
    case noFetchYet = 0
    case success = 1
    case failure = 2
    case throttled = 3
}

// MARK: - RemoteConfigFetchAndActivateStatus
// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Enums/RemoteConfigFetchAndActivateStatus

public enum RemoteConfigFetchAndActivateStatus : Int {
    case successFetchedFromRemote = 0
    case successUsingPreFetchedData = 1
    case error = 2
}

// MARK: - RemoteConfigSettings
// https://firebase.google.com/docs/reference/swift/firebaseremoteconfig/api/reference/Classes/RemoteConfigSettings

public final class RemoteConfigSettings {
    public var platformValue: com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings

    public init(platformValue: com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings) {
        self.platformValue = platformValue
    }

    public init() {
        platformValue = com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings.Builder().build()
    }

    /// Minimum interval (seconds) between fetches. Default is 43200 (12 hours).
    public var minimumFetchInterval: TimeInterval {
        get { Double(platformValue.getMinimumFetchIntervalInSeconds()) }
        set {
            platformValue = com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings.Builder()
                .setMinimumFetchIntervalInSeconds(Int64(newValue))
                .setFetchTimeoutInSeconds(Int64(fetchTimeout))
                .build()
        }
    }

    /// Timeout (seconds) for fetch requests. Default is 60.
    public var fetchTimeout: TimeInterval {
        get { Double(platformValue.getFetchTimeoutInSeconds()) }
        set {
            platformValue = com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings.Builder()
                .setMinimumFetchIntervalInSeconds(Int64(minimumFetchInterval))
                .setFetchTimeoutInSeconds(Int64(newValue))
                .build()
        }
    }
}
#endif
#endif
