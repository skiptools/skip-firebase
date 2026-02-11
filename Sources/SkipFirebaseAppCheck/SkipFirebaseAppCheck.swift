// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseappcheck/api/reference/Classes/AppCheck
// https://firebase.google.com/docs/reference/android/com/google/firebase/appcheck/FirebaseAppCheck

public final class AppCheck {
    public let platformValue: com.google.firebase.appcheck.FirebaseAppCheck

    public init(platformValue: com.google.firebase.appcheck.FirebaseAppCheck) {
        self.platformValue = platformValue
    }

    public static func appCheck() -> AppCheck {
        AppCheck(platformValue: com.google.firebase.appcheck.FirebaseAppCheck.getInstance())
    }

    public static func appCheck(app: FirebaseApp) -> AppCheck {
        AppCheck(platformValue: com.google.firebase.appcheck.FirebaseAppCheck.getInstance(app.app))
    }

    /// Sets the provider factory for App Check.
    /// On iOS this is a static method; on Android it calls `installAppCheckProviderFactory` on the instance.
    public static func setAppCheckProviderFactory(_ factory: AppCheckProviderFactory?) {
        guard let factory = factory else { return }
        com.google.firebase.appcheck.FirebaseAppCheck.getInstance().installAppCheckProviderFactory(factory.platformValue)
    }

    /// Requests a Firebase App Check token.
    /// - Parameter forcingRefresh: If `true`, forces a token refresh even if the cached token is still valid.
    /// - Returns: An `AppCheckToken` containing the token string and expiration date.
    public func token(forcingRefresh: Bool) async throws -> AppCheckToken {
        let result = platformValue.getAppCheckToken(forcingRefresh).await()
        return AppCheckToken(platformValue: result)
    }

    /// Requests a limited-use Firebase App Check token for server-side replay protection.
    /// - Returns: An `AppCheckToken` containing the token string and expiration date.
    public func limitedUseToken() async throws -> AppCheckToken {
        let result = platformValue.getLimitedUseAppCheckToken().await()
        return AppCheckToken(platformValue: result)
    }

    /// Controls whether the App Check SDK automatically refreshes the token when needed.
    public var isTokenAutoRefreshEnabled: Bool {
        // Android only exposes a setter; store and return the last set value
        get { _isTokenAutoRefreshEnabled }
        set {
            _isTokenAutoRefreshEnabled = newValue
            platformValue.setTokenAutoRefreshEnabled(newValue)
        }
    }
    private var _isTokenAutoRefreshEnabled: Bool = false

    /// The notification name posted when the App Check token changes.
    /// On Android this is backed by `AppCheckListener`.
    // SKIP @nobridge // no support for bridging notifications yet
    public static let appCheckTokenDidChangeNotification = Notification.Name("AppCheckAppCheckTokenDidChangeNotification")

    /// Adds a listener that is called when the App Check token changes.
    /// - Parameter listener: A closure called with the updated `AppCheckToken`.
    /// - Returns: An opaque listener handle that can be passed to `removeTokenChangeListener`.
    public func addTokenChangeListener(_ listener: @escaping (AppCheckToken) -> Void) -> AppCheckListenerHandle {
        let androidListener = com.google.firebase.appcheck.FirebaseAppCheck.AppCheckListener { token in
            let wrapped = AppCheckToken(platformValue: token)
            listener(wrapped)
            NotificationCenter.default.post(
                name: AppCheck.appCheckTokenDidChangeNotification,
                object: self,
                userInfo: [AppCheckTokenNotificationKey: wrapped]
            )
        }
        platformValue.addAppCheckListener(androidListener)
        return AppCheckListenerHandle(platformValue: androidListener)
    }

    /// Removes a previously added token change listener.
    public func removeTokenChangeListener(_ handle: AppCheckListenerHandle) {
        platformValue.removeAppCheckListener(handle.platformValue)
    }
}

// MARK: - AppCheckToken

/// A token returned by the App Check service, containing the token string and its expiration.
public final class AppCheckToken {
    public let platformValue: com.google.firebase.appcheck.AppCheckToken

    public init(platformValue: com.google.firebase.appcheck.AppCheckToken) {
        self.platformValue = platformValue
    }

    /// The token string to include in requests to your backend.
    public var token: String {
        platformValue.getToken()
    }

    /// The expiration date of this token.
    public var expirationDate: Date {
        Date(timeIntervalSince1970: Double(platformValue.getExpireTimeMillis()) / 1000.0)
    }
}

/// Key for retrieving the `AppCheckToken` from the `userInfo` dictionary of an `appCheckTokenDidChangeNotification`.
public let AppCheckTokenNotificationKey = "AppCheckTokenNotificationKey"

// MARK: - AppCheckListenerHandle

/// An opaque handle for a registered token change listener.
public class AppCheckListenerHandle {
    public let platformValue: com.google.firebase.appcheck.FirebaseAppCheck.AppCheckListener

    public init(platformValue: com.google.firebase.appcheck.FirebaseAppCheck.AppCheckListener) {
        self.platformValue = platformValue
    }
}

// MARK: - AppCheckProviderFactory

/// A wrapper around the Android `AppCheckProviderFactory` that matches the Swift `AppCheckProviderFactory` protocol.
public class AppCheckProviderFactory {
    public let platformValue: com.google.firebase.appcheck.AppCheckProviderFactory

    public init(platformValue: com.google.firebase.appcheck.AppCheckProviderFactory) {
        self.platformValue = platformValue
    }
}

// MARK: - AppCheckDebugProviderFactory

/// A factory that creates debug App Check providers, useful for testing.
/// On iOS this is `AppCheckDebugProviderFactory`; on Android it is `DebugAppCheckProviderFactory`.
public class AppCheckDebugProviderFactory: AppCheckProviderFactory {
    public init() {
        super.init(platformValue: com.google.firebase.appcheck.debug.DebugAppCheckProviderFactory.getInstance())
    }
}

// MARK: - AppCheckError

/// Error codes for App Check operations, matching the Swift `AppCheckErrorCode` enum.
public enum AppCheckErrorCode: Int {
    case unknown = 0
    case serverUnreachable = 1
    case invalidConfiguration = 2
    case keychain = 3
    case unsupported = 4
}

/// The error domain for App Check errors.
public let AppCheckErrorDomain = "FIRAppCheckErrorDomain"

#endif
#endif
