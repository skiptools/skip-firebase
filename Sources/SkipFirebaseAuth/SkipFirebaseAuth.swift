// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseAuth)
@_exported import FirebaseAuth
#elseif SKIP
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
        do {
            let result = platformValue.signInWithEmailAndPassword(email, password).await()
            return AuthDataResult(result)
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
    }

    /// Throws `FirebaseAuthWeakPasswordException`/`FirebaseAuthInvalidCredentialsException`/`FirebaseAuthUserCollisionException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#createUserWithEmailAndPassword(java.lang.String,java.lang.String)
    public func createUser(withEmail email: String, password: String) async throws -> AuthDataResult {
        do {
            let result = platformValue.createUserWithEmailAndPassword(email, password).await()
            return AuthDataResult(result)
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
    }

    /// Does not throw from Kotlin
    public func signOut() throws {
        platformValue.signOut()
    }

    /// Throws `FirebaseAuthInvalidUserException`
    public func sendPasswordReset(withEmail email: String) async throws {
        do {
            platformValue.sendPasswordResetEmail(email).await()
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
    }

    /// Throws `Exception`
    public func signInAnonymously() async throws -> AuthDataResult {
        let result = platformValue.signInAnonymously().await()
        return AuthDataResult(result)
    }

    /// Send a sign-in link to the given email address.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#sendSignInLinkToEmail(java.lang.String,com.google.firebase.auth.ActionCodeSettings)
    public func sendSignInLink(toEmail email: String, actionCodeSettings: ActionCodeSettings) async throws {
        platformValue.sendSignInLinkToEmail(email, actionCodeSettings.platformValue).await()
    }

    /// iOS-style completion API for sending an email sign-in link.
    public func sendSignInLink(toEmail email: String, actionCodeSettings: ActionCodeSettings, completion: @escaping (Error?) -> Void) {
        platformValue
            .sendSignInLinkToEmail(email, actionCodeSettings.platformValue)
            .addOnSuccessListener { _ in completion(nil) }
            .addOnFailureListener { exception in completion(mapAuthNSError(exception)) }
    }

    /// Whether the link is a sign-in-with-email link.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#isSignInWithEmailLink(java.lang.String)
    public func isSignIn(withEmailLink link: String) -> Bool {
        platformValue.isSignInWithEmailLink(link)
    }

    /// Sign in using an email and the link previously sent via `sendSignInLink(toEmail:actionCodeSettings:)`.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseAuth#signInWithEmailLink(java.lang.String,java.lang.String)
    public func signInWithLink(withEmail email: String, link: String) async throws -> AuthDataResult {
        let result = platformValue.signInWithEmailLink(email, link).await()
        return AuthDataResult(result)
    }

    /// iOS-style completion API for sign-in with email link.
    public func signInWithLink(withEmail email: String, link: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        platformValue
            .signInWithEmailLink(email, link)
            .addOnSuccessListener { result in completion(AuthDataResult(result), nil) }
            .addOnFailureListener { exception in completion(nil, mapAuthNSError(exception)) }
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

    /// The identity providers linked to this account, in the order Firebase
    /// returns them.
    ///
    /// Android additionally reports a synthetic `"firebase"` entry that iOS does
    /// not; it is filtered out so `providerData.first?.providerID` means the same
    /// thing on both platforms.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#getProviderData()
    public var providerData: [UserInfo] {
        var infos: [UserInfo] = []
        for info in platformValue.providerData {
            if info.providerId == com.google.firebase.auth.FirebaseAuthProvider.PROVIDER_ID { continue }
            infos.append(UserInfo(info))
        }
        return infos
    }

    public func createProfileChangeRequest() -> UserProfileChangeRequest {
        return UserProfileChangeRequest(self)
    }

    
    /// Throws `FirebaseAuthInvalidUserException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#sendemailverification
    public func sendEmailVerification() async throws {
        do {
            platformValue.sendEmailVerification().await()
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
    }
    
    /// Sends a verification link to `email`; the account's address only changes
    /// once the user follows it. Matches iOS
    /// `sendEmailVerification(beforeUpdatingEmail:)`.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#verifyBeforeUpdateEmail(java.lang.String)
    public func sendEmailVerification(beforeUpdatingEmail email: String) async throws {
        platformValue.verifyBeforeUpdateEmail(email).await()
    }

    /// Throws `FirebaseAuthInvalidUserException`/`FirebaseAuthRecentLoginRequiredException`
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#reauthenticate(com.google.firebase.auth.AuthCredential)
    public func reauthenticate(with credential: AuthCredential) async throws {
        do {
            platformValue.reauthenticate(credential.platformValue).await()
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
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
        do {
            platformValue.delete().await()
        } catch is com.google.firebase.FirebaseException {
            throw mapAuthNSError(error)
        }
    }

    /// Refreshes the user's profile data (e.g. `isEmailVerified`) from the Firebase server.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/FirebaseUser#reload()
    public func reload() async throws {
        platformValue.reload().await()
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

/// A single identity provider entry from `User.providerData`.
/// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/UserInfo
public class UserInfo: KotlinConverting<com.google.firebase.auth.UserInfo> {
    public let platformValue: com.google.firebase.auth.UserInfo

    public init(_ platformValue: com.google.firebase.auth.UserInfo) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.UserInfo {
        platformValue
    }

    public var providerID: String {
        platformValue.providerId
    }

    public var uid: String {
        platformValue.uid
    }

    public var displayName: String? {
        platformValue.displayName
    }

    public var email: String? {
        platformValue.email
    }

    public var phoneNumber: String? {
        platformValue.phoneNumber
    }

    public var photoURL: URL? {
        guard let uri = platformValue.photoUrl else { return nil }
        return URL(string: uri.toString())
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

/// The subset of `FIRAuthErrorCode` that Android's `FirebaseAuthException.errorCode`
/// can be resolved to. Raw values are Apple's, so `(error as NSError).code` means
/// the same thing on both platforms.
public enum AuthErrorCode: Int {
    case invalidCustomToken = 17000
    case customTokenMismatch = 17002
    case invalidCredential = 17004
    case userDisabled = 17005
    case operationNotAllowed = 17006
    case emailAlreadyInUse = 17007
    case invalidEmail = 17008
    case wrongPassword = 17009
    case tooManyRequests = 17010
    case userNotFound = 17011
    case accountExistsWithDifferentCredential = 17012
    case requiresRecentLogin = 17014
    case providerAlreadyLinked = 17015
    case noSuchProvider = 17016
    case invalidUserToken = 17017
    case networkError = 17020
    case userTokenExpired = 17021
    case invalidAPIKey = 17023
    case userMismatch = 17024
    case credentialAlreadyInUse = 17025
    case weakPassword = 17026
    case appNotAuthorized = 17028
    case expiredActionCode = 17029
    case invalidActionCode = 17030
    case invalidRecipientEmail = 17033
    case missingEmail = 17034
    case internalError = 17999
}

/// Android's `FirebaseAuthException.getErrorCode()` string → the matching
/// `FIRAuthErrorCode` raw value.
///
/// Note on newer Firebase Android versions: with email-enumeration protection
/// enabled, `ERROR_USER_NOT_FOUND` and `ERROR_WRONG_PASSWORD` are collapsed into
/// `ERROR_INVALID_CREDENTIAL` — the same thing iOS does, so callers that handle
/// `.invalidCredential` stay correct on both platforms.
fileprivate func authErrorCode(forAndroidCode code: String) -> Int? {
    switch code {
    case "ERROR_INVALID_CUSTOM_TOKEN": return AuthErrorCode.invalidCustomToken.rawValue
    case "ERROR_CUSTOM_TOKEN_MISMATCH": return AuthErrorCode.customTokenMismatch.rawValue
    case "ERROR_INVALID_CREDENTIAL": return AuthErrorCode.invalidCredential.rawValue
    case "ERROR_USER_DISABLED": return AuthErrorCode.userDisabled.rawValue
    case "ERROR_OPERATION_NOT_ALLOWED": return AuthErrorCode.operationNotAllowed.rawValue
    case "ERROR_EMAIL_ALREADY_IN_USE": return AuthErrorCode.emailAlreadyInUse.rawValue
    case "ERROR_INVALID_EMAIL": return AuthErrorCode.invalidEmail.rawValue
    case "ERROR_WRONG_PASSWORD": return AuthErrorCode.wrongPassword.rawValue
    case "ERROR_TOO_MANY_REQUESTS": return AuthErrorCode.tooManyRequests.rawValue
    case "ERROR_USER_NOT_FOUND": return AuthErrorCode.userNotFound.rawValue
    case "ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL": return AuthErrorCode.accountExistsWithDifferentCredential.rawValue
    case "ERROR_REQUIRES_RECENT_LOGIN": return AuthErrorCode.requiresRecentLogin.rawValue
    case "ERROR_PROVIDER_ALREADY_LINKED": return AuthErrorCode.providerAlreadyLinked.rawValue
    case "ERROR_NO_SUCH_PROVIDER": return AuthErrorCode.noSuchProvider.rawValue
    case "ERROR_INVALID_USER_TOKEN": return AuthErrorCode.invalidUserToken.rawValue
    case "ERROR_USER_TOKEN_EXPIRED": return AuthErrorCode.userTokenExpired.rawValue
    case "ERROR_INVALID_API_KEY": return AuthErrorCode.invalidAPIKey.rawValue
    case "ERROR_USER_MISMATCH": return AuthErrorCode.userMismatch.rawValue
    case "ERROR_CREDENTIAL_ALREADY_IN_USE": return AuthErrorCode.credentialAlreadyInUse.rawValue
    case "ERROR_WEAK_PASSWORD": return AuthErrorCode.weakPassword.rawValue
    case "ERROR_APP_NOT_AUTHORIZED": return AuthErrorCode.appNotAuthorized.rawValue
    case "ERROR_EXPIRED_ACTION_CODE": return AuthErrorCode.expiredActionCode.rawValue
    case "ERROR_INVALID_ACTION_CODE": return AuthErrorCode.invalidActionCode.rawValue
    case "ERROR_INVALID_RECIPIENT_EMAIL": return AuthErrorCode.invalidRecipientEmail.rawValue
    case "ERROR_MISSING_EMAIL": return AuthErrorCode.missingEmail.rawValue
    case "ERROR_INTERNAL_ERROR": return AuthErrorCode.internalError.rawValue
    default: return nil
    }
}

/// Map Android auth exceptions to iOS-style NSError when feasible.
///
/// Without this every auth failure reaches Swift as a bare `ErrorException`
/// whose `localizedDescription` is the generic bridge text ("The operation could
/// not be completed. (SwiftJNI.ThrowableError error 1.)") — a caller cannot tell
/// "wrong password" from "email already in use", and any message it shows is
/// wrong. Mirrors `asNSError(functionsException:)` in SkipFirebaseFunctions and
/// `asNSError(firestoreException:)` in SkipFirebaseFirestore.
fileprivate func mapAuthNSError(_ exception: Exception) -> Error {
    // Network failures are not FirebaseAuthExceptions and carry no error code.
    if let networkException = exception as? com.google.firebase.FirebaseNetworkException {
        var networkInfo: [String: Any] = [:]
        if let detailMessage = networkException.message {
            networkInfo[NSLocalizedDescriptionKey] = detailMessage
        }
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.networkError.rawValue, userInfo: networkInfo)
    }

    guard let authException = exception as? com.google.firebase.auth.FirebaseAuthException else {
        return ErrorException(exception)
    }

    var userInfo: [String: Any] = [:]
    if let detailMessage = authException.message {
        // iOS puts the human-readable reason in localizedDescription; keep the
        // Android message there so existing message-matching callers still work.
        userInfo[NSLocalizedDescriptionKey] = detailMessage
        if detailMessage.contains("@") { // naive check for an email-like token
            userInfo[AuthErrorUserInfoEmailKey] = detailMessage
        }
    }

    if let code = authErrorCode(forAndroidCode: authException.errorCode) {
        return NSError(domain: AuthErrorDomain, code: code, userInfo: userInfo)
    }

    // Unknown error code: fall back to the exception class, which is coarser but
    // still classifies the three cases callers care about most.
    if exception is com.google.firebase.auth.FirebaseAuthUserCollisionException {
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.accountExistsWithDifferentCredential.rawValue, userInfo: userInfo)
    }
    if exception is com.google.firebase.auth.FirebaseAuthWeakPasswordException {
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.weakPassword.rawValue, userInfo: userInfo)
    }
    if exception is com.google.firebase.auth.FirebaseAuthInvalidUserException {
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.userNotFound.rawValue, userInfo: userInfo)
    }
    if exception is com.google.firebase.auth.FirebaseAuthInvalidCredentialsException {
        return NSError(domain: AuthErrorDomain, code: AuthErrorCode.invalidCredential.rawValue, userInfo: userInfo)
    }
    return NSError(domain: AuthErrorDomain, code: AuthErrorCode.internalError.rawValue, userInfo: userInfo)
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

    /// Build a credential for sign-in via an email link.
    ///
    /// On iOS, Firebase exposes this as `EmailAuthProvider.credential(withEmail:link:)`, but
    /// that signature collides with `credential(withEmail:password:)` at the JVM level
    /// (both erase to `(String, String) -> AuthCredential`). Use this method on Android
    /// and gate iOS callers with `#if !SKIP`.
    /// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/EmailAuthProvider#getCredentialWithLink(java.lang.String,java.lang.String)
    public static func credentialWithLink(email: String, link: String) -> AuthCredential {
        let credential = com.google.firebase.auth.EmailAuthProvider.getCredentialWithLink(email, link)
        return AuthCredential(credential)
    }
}

// https://firebase.google.com/docs/reference/swift/firebaseauth/api/reference/Classes/ActionCodeSettings
// https://firebase.google.com/docs/reference/android/com/google/firebase/auth/ActionCodeSettings
public final class ActionCodeSettings: KotlinConverting<com.google.firebase.auth.ActionCodeSettings> {
    public var url: URL?
    public var handleCodeInApp: Bool = false
    private var iOSBundleIDValue: String?
    private var androidPackageName: String?
    private var androidInstallIfNotAvailable: Bool = false
    private var androidMinimumVersion: String?
    public var dynamicLinkDomain: String?
    public var linkDomain: String?

    public init() {}

    public func setIOSBundleID(_ bundleID: String) {
        self.iOSBundleIDValue = bundleID
    }

    public func setAndroidPackageName(_ packageName: String, installIfNotAvailable: Bool, minimumVersion: String?) {
        self.androidPackageName = packageName
        self.androidInstallIfNotAvailable = installIfNotAvailable
        self.androidMinimumVersion = minimumVersion
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.auth.ActionCodeSettings {
        return platformValue
    }

    public var platformValue: com.google.firebase.auth.ActionCodeSettings {
        let builder = com.google.firebase.auth.ActionCodeSettings.newBuilder()
        if let url {
            builder.setUrl(url.absoluteString)
        }
        builder.setHandleCodeInApp(handleCodeInApp)
        if let androidPackageName {
            builder.setAndroidPackageName(androidPackageName, androidInstallIfNotAvailable, androidMinimumVersion)
        }
        if let domain = linkDomain ?? dynamicLinkDomain {
            builder.setDynamicLinkDomain(domain)
        }
        return builder.build()
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
