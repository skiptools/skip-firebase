// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import Foundation
import SkipFirebaseCore
import android.app.Activity
import kotlinx.coroutines.tasks.await
import android.net.Uri
import skip.ui.__

// https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/Auth
// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth

public final class Auth {
    public let platformValue: com.google.firebase.auth.FirebaseAuth

    public init(platformValue: com.google.firebase.auth.FirebaseAuth) {
        self.platformValue = platformValue
    }

    public static func auth() -> Auth {
        Auth(platformValue: com.google.firebase.auth.FirebaseAuth.getInstance())
    }

    public static func auth(app: FirebaseApp) -> Auth {
        Auth(platformValue: com.google.firebase.auth.FirebaseAuth.getInstance(app.app))
    }

    public var app: FirebaseApp {
        FirebaseApp(app: platformValue.getApp())
    }

    public var currentUser: User? {
        guard let user = platformValue.currentUser else { return nil }
        return User(user)
    }

    /// Throws `FirebaseAuthInvalidUserException`/`FirebaseAuthInvalidCredentialsException`/`FirebaseAuthInvalidCredentialsException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#signInWithEmailAndPassword(java.lang.String,java.lang.String)
    public func signIn(withEmail email: String, password: String) async throws -> AuthDataResult {
        let result = platformValue.signInWithEmailAndPassword(email, password).await()
        return AuthDataResult(result)
    }

    /// Throws `FirebaseAuthWeakPasswordException`/`FirebaseAuthInvalidCredentialsException`/`FirebaseAuthUserCollisionException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#createUserWithEmailAndPassword(java.lang.String,java.lang.String)
    public func createUser(withEmail email: String, password: String) async throws -> AuthDataResult {
        let result = platformValue.createUserWithEmailAndPassword(email, password).await()
        return AuthDataResult(result)
    }

    /// Does not throw from Kotlin
    public func signOut() throws {
        platformValue.signOut()
    }

    /// Throws `FirebaseAuthInvalidUserException`
    public func sendPasswordReset(withEmail email: String) async throws {
        platformValue.sendPasswordResetEmail(email).await()
    }

    /// Throws `Exception`
    public func signInAnonymously() async throws -> AuthDataResult {
        let result = platformValue.signInAnonymously().await()
        return AuthDataResult(result)
    }

    public func useEmulator(withHost host: String, port: Int) {
        platformValue.useEmulator(host, port)
    }

    /// Throws `FirebaseAuthInvalidCredentialsException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#signInWithCredential(com.google.firebase.auth.AuthCredential)
    public func signIn(with credential: AuthCredential) async throws -> AuthDataResult {
        let result = try platformValue.signInWithCredential(credential.platformValue).await()
        return AuthDataResult(result)
    }

    /// iOS-style completion API for sign-in with credential
    public func signIn(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        platformValue
            .signInWithCredential(credential.platformValue)
            .addOnSuccessListener { result in
                completion(AuthDataResult(result), nil)
            }
            .addOnFailureListener { exception in
                completion(nil, mapAuthNSError(exception))
            }
    }

    /// Interactive sign-in using an `OAuthProvider` (OIDC/SAML). Requires current Activity.
    /// Throws if there is no foreground Activity.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#startActivityForSignInWithProvider(android.app.Activity,com.google.firebase.auth.OAuthProvider)
    public func signIn(with provider: OAuthProvider) async throws -> AuthDataResult {
        guard let activity: Activity = UIApplication.shared.androidActivity else {
            throw NSError(domain: "SkipFirebaseAuth", code: -10, userInfo: [NSLocalizedDescriptionKey: "No current Android activity available for OAuth sign-in"])
        }
        let result = try platformValue.startActivityForSignInWithProvider(activity, provider.buildPlatformProvider()).await()
        return AuthDataResult(result)
    }

    /// Whether the specific URL is handled by Auth.
    /// On Android, map this to email-link detection.
    public func canHandle(_ url: URL) -> Bool {
        platformValue.isSignInWithEmailLink(url.absoluteString)
    }

    /// iOS-style completion API for interactive provider sign-in
    public func signIn(with provider: OAuthProvider, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        guard let activity: Activity = UIApplication.shared.androidActivity else {
            completion(nil, NSError(domain: "SkipFirebaseAuth", code: -10, userInfo: [NSLocalizedDescriptionKey: "No current Android activity available for OAuth sign-in"]))
            return
        }
        platformValue
            .startActivityForSignInWithProvider(activity, provider.buildPlatformProvider())
            .addOnSuccessListener { result in
                completion(AuthDataResult(result), nil)
            }
            .addOnFailureListener { exception in
                completion(nil, mapAuthNSError(exception))
            }
    }

    /// iOS-compatible API to fetch sign-in methods for an email
    public func fetchSignInMethods(forEmail email: String, completion: @escaping ([String]?, Error?) -> Void) {
        platformValue
            .fetchSignInMethodsForEmail(email)
            .addOnSuccessListener { result in
                guard let methods = result.getSignInMethods() else { completion([], nil); return }
                var swift: [String] = []
                let iterator = methods.iterator()
                while iterator.hasNext() {
                    if let v = iterator.next() {
                        swift.append(String(describing: v))
                    }
                }
                completion(swift, nil)
            }
            .addOnFailureListener { exception in
                completion(nil, mapAuthNSError(exception))
            }
    }

    public func addStateDidChangeListener(_ listener: @escaping (Auth, User?) -> Void) -> AuthStateListener {
        let stateListener = com.google.firebase.auth.FirebaseAuth.AuthStateListener { auth in
            let user = auth.currentUser != nil ? User(auth.currentUser!) : nil
            listener(Auth(platformValue: auth), user)
        }
        platformValue.addAuthStateListener(stateListener)
        return AuthStateListener(platformValue: stateListener)
    }

    public func removeStateDidChangeListener(_ listenerHandle: Any) {
        if let handle = listenerHandle as? AuthStateListener {
            platformValue.removeAuthStateListener(handle.platformValue)
        }
    }
}

public class AuthDataResult: Equatable, KotlinConverting<com.google.firebase.auth.AuthResult> {
    public let platformValue: com.google.firebase.auth.AuthResult

    public init(_ platformValue: com.google.firebase.auth.AuthResult) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.AuthResult {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    public var user: User {
        User(platformValue.user!)
    }

    public var additionalUserInfo: AdditionalUserInfo? {
        guard let info = platformValue.additionalUserInfo else { return nil }
        return AdditionalUserInfo(info)
    }
}

public class AuthStateListener {
    public let platformValue: com.google.firebase.auth.FirebaseAuth.AuthStateListener

    public init(platformValue: com.google.firebase.auth.FirebaseAuth.AuthStateListener) {
        self.platformValue = platformValue
    }
}

public class User: Equatable, KotlinConverting<com.google.firebase.auth.FirebaseUser> {
    public let platformValue: com.google.firebase.auth.FirebaseUser

    public init(_ platformValue: com.google.firebase.auth.FirebaseUser) {
        self.platformValue = platformValue
    }

    // Bridging this function creates a Swift function that "overrides" nothing
    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.FirebaseUser {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    public var isAnonymous: Bool {
        platformValue.isAnonymous
    }
    
    public var isEmailVerified: Bool {
        platformValue.isEmailVerified
    }

    public var providerID: String? {
        platformValue.providerId
    }

    public var uid: String {
        platformValue.uid
    }

    public var displayName: String? {
        platformValue.displayName
    }

    public var photoURL: URL? {
        guard let uri = platformValue.photoUrl else { return nil }
        return URL(string: uri.toString())!
    }

    public var email: String? {
        platformValue.email
    }

    public var phoneNumber: String? {
        platformValue.phoneNumber
    }

    public var metadata: UserMetadata {
        UserMetadata(platformValue.metadata)
    }

    public func createProfileChangeRequest() -> UserProfileChangeRequest {
        return UserProfileChangeRequest(self)
    }

    
    /// Throws `FirebaseAuthInvalidUserException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#sendemailverification
    public func sendEmailVerification() async throws {
        try await platformValue.sendEmailVerification().await()
    }
    
    /// Throws `FirebaseAuthInvalidUserException`/`FirebaseAuthRecentLoginRequiredException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#reauthenticate(com.google.firebase.auth.AuthCredential)
    public func reauthenticate(with credential: AuthCredential) async throws {
        platformValue.reauthenticate(credential.platformValue).await()
    }

    /// Link generic credential
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#linkwithcredential
    public func link(with credential: AuthCredential) async throws -> AuthDataResult {
        let result = try platformValue.linkWithCredential(credential.platformValue).await()
        return AuthDataResult(result)
    }

    /// iOS-style completion API for link with credential
    public func link(with credential: AuthCredential, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        platformValue
            .linkWithCredential(credential.platformValue)
            .addOnSuccessListener { result in
                completion(AuthDataResult(result), nil)
            }
            .addOnFailureListener { exception in
                completion(nil, mapAuthNSError(exception))
            }
    }

    /// Interactive link with provider using current Activity
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#startactivityforlinkwithprovider(android.app.Activity,com.google.firebase.auth.OAuthProvider)
    public func link(with provider: OAuthProvider) async throws -> AuthDataResult {
        guard let activity: Activity = UIApplication.shared.androidActivity else {
            throw NSError(domain: "SkipFirebaseAuth", code: -11, userInfo: [NSLocalizedDescriptionKey: "No current Android activity available for OAuth link"])
        }
        let result = try platformValue.startActivityForLinkWithProvider(activity, provider.buildPlatformProvider()).await()
        return AuthDataResult(result)
    }

    /// Interactive reauthenticate with provider using current Activity
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#startactivityforreauthenticatewithprovider(android.app.Activity,com.google.firebase.auth.OAuthProvider)
    public func reauthenticate(with provider: OAuthProvider) async throws -> AuthDataResult {
        guard let activity: Activity = UIApplication.shared.androidActivity else {
            throw NSError(domain: "SkipFirebaseAuth", code: -12, userInfo: [NSLocalizedDescriptionKey: "No current Android activity available for OAuth reauthenticate"])
        }
        let result = try platformValue.startActivityForReauthenticateWithProvider(activity, provider.buildPlatformProvider()).await()
        return AuthDataResult(result)
    }

    /// Throws `FirebaseAuthInvalidUserException`/`FirebaseAuthRecentLoginRequiredException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#delete()
    public func delete() async throws {
        platformValue.delete().await()
    }

    public func getIDToken(forcingRefresh: Bool = false) async throws -> String {
        let result = try platformValue.getIdToken(forcingRefresh).await()
        guard let token = result.token else {
            throw NSError(domain: "FirebaseAuthError", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Failed to get ID token"
            ])
        }
        return token
    }
}

/// Additional user information associated with an auth result
public final class AdditionalUserInfo: KotlinConverting<com.google.firebase.auth.AdditionalUserInfo> {
    public let platformValue: com.google.firebase.auth.AdditionalUserInfo

    public init(_ platformValue: com.google.firebase.auth.AdditionalUserInfo) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.AdditionalUserInfo {
        platformValue
    }

    public var isNewUser: Bool { platformValue.isNewUser }
    public var providerID: String? { platformValue.getProviderId() }
    public var username: String? { platformValue.getUsername() }

    /// Minimal compatibility: profile not bridged on Android
    public var profile: [AnyHashable: Any]? { nil }
}

// MARK: - iOS-compatible Auth error surface

public let AuthErrorDomain = "FIRAuthErrorDomain"
public let AuthErrorUserInfoEmailKey = "FIRAuthErrorUserInfoEmailKey"

public enum AuthErrorCode: Int {
    case accountExistsWithDifferentCredential = 17012
}

/// Map Android auth exceptions to iOS-style NSError when feasible
fileprivate func mapAuthNSError(_ exception: Exception) -> Error {
    if let collision = exception as? com.google.firebase.auth.FirebaseAuthUserCollisionException {
        var userInfo: [String: Any] = [:]
        // Try to extract email if available
        if let emailProvider = (collision as? com.google.firebase.auth.FirebaseAuthException) {
            // Some exceptions expose the email via getMessage or provider data; best effort only
            let message = String(describing: emailProvider.message ?? "")
            if message.contains("@") { // naive check for email-like token
                userInfo[AuthErrorUserInfoEmailKey] = message
            }
        }
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.accountExistsWithDifferentCredential.rawValue, userInfo: userInfo)
    }
    return ErrorException(exception)
}

// Provide a FirebaseAuth namespace so app code can reference `FirebaseAuth.User` on Android
public enum FirebaseAuth {
    public typealias User = SkipFirebaseAuth.User
}

public class UserMetadata {
    // On iOS, UserMetadata is never nil but its properties can be. On Android, it's the opposite.
    public let userMetadata: com.google.firebase.auth.FirebaseUserMetadata?

    public init(_ userMetadata: com.google.firebase.auth.FirebaseUserMetadata?) {
        self.userMetadata = userMetadata
    }

    public var creationDate: Date? {
        guard let milliseconds = userMetadata?.getCreationTimestamp() else { return nil }
        return Date(timeIntervalSince1970: Double(milliseconds) / 1000)
    }

    public var lastSignInDate: Date? {
        guard let milliseconds = userMetadata?.getLastSignInTimestamp() else { return nil }
        return Date(timeIntervalSince1970: Double(milliseconds) / 1000)
    }
}

public class UserProfileChangeRequest/*: KotlinConverting<com.google.firebase.auth.UserProfileChangeRequest>*/ {
    var user: User

    fileprivate init(user: User) {
        self.user = user
    }

    public var displayName: String?

    /// Throws `FirebaseAuthInvalidUserException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#updateProfile(com.google.firebase.auth.UserProfileChangeRequest)
    public func commitChanges() async throws {
        let builder = com.google.firebase.auth.UserProfileChangeRequest.Builder()

        if let displayName {
            builder.setDisplayName(displayName)
        }

        let platformChangeRequest: com.google.firebase.auth.UserProfileChangeRequest = builder.build()

        user.platformValue.updateProfile(platformChangeRequest).await()
    }
}

public class AuthCredential: KotlinConverting<com.google.firebase.auth.AuthCredential> {
    public let platformValue: com.google.firebase.auth.AuthCredential
    
    public init(_ platformValue: com.google.firebase.auth.AuthCredential) {
        self.platformValue = platformValue
    }

    // Bridging this function creates a Swift function that "overrides" nothing
    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.AuthCredential {
        platformValue
    }
}

public class EmailAuthProvider {
    public static func credential(withEmail email: String, password: String) -> AuthCredential {
        let credential = com.google.firebase.auth.EmailAuthProvider.getCredential(email, password)
        return AuthCredential(credential)
    }
}

// https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/OAuthProvider
// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/OAuthProvider
public final class OAuthProvider {
    public let providerID: String
    public var customParameters: [String : String] = [:]
    public var scopes: [String] = []

    public init(providerID: String) {
        self.providerID = providerID
    }

    /// Build Android OAuthProvider from current configuration
    internal func buildPlatformProvider() -> com.google.firebase.auth.OAuthProvider {
        let builder = com.google.firebase.auth.OAuthProvider.newBuilder(providerID)
        for (key, value) in customParameters {
            builder.addCustomParameter(key, value)
        }
        if !scopes.isEmpty {
            builder.setScopes(scopes.toList())
        }
        return builder.build()
    }

    /// iOS-compatible API. Starts interactive OAuth flow and returns a credential in the completion.
    public func getCredentialWith(_ presentingAnchor: Any?, completion: @escaping (AuthCredential?, Error?) -> Void) {
        guard let activity: Activity = UIApplication.shared.androidActivity else {
            completion(nil, NSError(domain: "SkipFirebaseAuth", code: -10, userInfo: [NSLocalizedDescriptionKey: "No current Android activity available for OAuth sign-in"]))
            return
        }
        let auth = com.google.firebase.auth.FirebaseAuth.getInstance()
        auth.startActivityForSignInWithProvider(activity, buildPlatformProvider())
            .addOnSuccessListener { result in
                if let cred = result.credential {
                    completion(AuthCredential(cred), nil)
                } else {
                    completion(nil, nil)
                }
            }
            .addOnFailureListener { exception in
                completion(nil, ErrorException(exception))
            }
    }

    /// Build an OAuth credential from tokens
    public static func credential(providerID: String, idToken: String? = nil, rawNonce: String? = nil, accessToken: String? = nil) -> AuthCredential {
        let builder = com.google.firebase.auth.OAuthProvider.newCredentialBuilder(providerID)
        if let idToken, let rawNonce {
            builder.setIdTokenWithRawNonce(idToken, rawNonce)
        } else if let idToken {
            builder.setIdToken(idToken)
        }
        if let accessToken {
            builder.setAccessToken(accessToken)
        }
        return AuthCredential(builder.build())
    }

    /// Convenience instance API matching iOS style
    public func credential(withIDToken idToken: String? = nil, accessToken: String? = nil, rawNonce: String? = nil) -> AuthCredential {
        return OAuthProvider.credential(providerID: providerID, idToken: idToken, rawNonce: rawNonce, accessToken: accessToken)
    }
}

#endif
#endif
