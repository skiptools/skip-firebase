// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseFunctions)
@_exported import FirebaseFunctions
#elseif SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

public typealias Timestamp = SkipFirebaseCore.Timestamp

// https://firebase.google.com/docs/reference/swift/firebasefunctions/api/reference/Classes/Functions
// https://firebase.google.com/docs/reference/android/com/google/firebase/functions/FirebaseFunctions

public final class HTTPSCallableOptions {
    public let requireLimitedUseAppCheckTokens: Bool

    public init(requireLimitedUseAppCheckTokens: Bool) {
        self.requireLimitedUseAppCheckTokens = requireLimitedUseAppCheckTokens
    }

    var androidOptions: com.google.firebase.functions.HttpsCallableOptions {
        let builder = com.google.firebase.functions.HttpsCallableOptions.Builder()
        builder.limitedUseAppCheckTokens = requireLimitedUseAppCheckTokens
        return builder.build()
    }
}

public final class Functions {
    public let functions: com.google.firebase.functions.FirebaseFunctions

    public init(functions: com.google.firebase.functions.FirebaseFunctions) {
        self.functions = functions
    }

    public static func functions() -> Functions {
        Functions(functions: com.google.firebase.functions.FirebaseFunctions.getInstance())
    }

    public static func functions(app: FirebaseApp) -> Functions {
        Functions(functions: com.google.firebase.functions.FirebaseFunctions.getInstance(app.app))
    }

    public static func functions(region: String) -> Functions {
        Functions(functions: com.google.firebase.functions.FirebaseFunctions.getInstance(region))
    }

    public static func functions(app: FirebaseApp, region: String) -> Functions {
        Functions(functions: com.google.firebase.functions.FirebaseFunctions.getInstance(app.app, region))
    }

    public func useEmulator(withHost host: String, port: Int) {
        functions.useEmulator(host, port)
    }

    public func httpsCallable(_ name: String) -> HTTPSCallable {
        HTTPSCallable(functions.getHttpsCallable(name))
    }

    public func httpsCallable(_ name: String, options: HTTPSCallableOptions) -> HTTPSCallable {
        HTTPSCallable(functions.getHttpsCallable(name, options.androidOptions))
    }

    public func httpsCallable(_ url: URL) -> HTTPSCallable {
        HTTPSCallable(functions.getHttpsCallableFromUrl(java.net.URL(url.absoluteString)))
    }

    public func httpsCallable(_ url: URL, options: HTTPSCallableOptions) -> HTTPSCallable {
        HTTPSCallable(functions.getHttpsCallableFromUrl(java.net.URL(url.absoluteString), options.androidOptions))
    }
}

public class HTTPSCallable: KotlinConverting<com.google.firebase.functions.HttpsCallableReference> {
    public let platformValue: com.google.firebase.functions.HttpsCallableReference

    public init(_ platformValue: com.google.firebase.functions.HttpsCallableReference) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.functions.HttpsCallableReference {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    public var timeoutInterval: TimeInterval {
        get { Double(platformValue.timeout) / 1000.0 }
        set { platformValue.setTimeout(Int64(newValue * 1000), java.util.concurrent.TimeUnit.MILLISECONDS) }
    }

    public func call(_ data: Any? = nil) async throws -> HTTPSCallableResult {
        do {
            let task = data == nil ? platformValue.call() : platformValue.call(data!.kotlin())
            return HTTPSCallableResult(try await task.await())
        } catch is com.google.firebase.functions.FirebaseFunctionsException {
            throw asNSError(functionsException: error)
        }
    }

    public func call(_ data: Any? = nil,
               completion: @escaping (HTTPSCallableResult?,
                                      Error?) -> Void) {
        (data == nil ? platformValue.call() : platformValue.call(data!.kotlin()))
        .addOnSuccessListener { httpsCallableResult in
            completion(HTTPSCallableResult(httpsCallableResult), nil)
        }
        .addOnFailureListener { exception in
            if let functionsException = exception as? com.google.firebase.functions.FirebaseFunctionsException {
                completion(nil, asNSError(functionsException: functionsException))
            } else {
                completion(nil, ErrorException(exception))
            }
        }
    }
}

public class HTTPSCallableResult: KotlinConverting<com.google.firebase.functions.HttpsCallableResult> {
    public let platformValue: com.google.firebase.functions.HttpsCallableResult

    public init(_ platformValue: com.google.firebase.functions.HttpsCallableResult) {
        self.platformValue = platformValue
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.functions.HttpsCallableResult {
        platformValue
    }

    public var description: String {
        platformValue.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.platformValue == rhs.platformValue
    }

    public var data: Any {
        // Convert Kotlin/Java types (HashMap, ArrayList) to Swift types (Dictionary, Array)
        // This prevents JNI crashes when Skip's bridge tries to call .kotlin() on raw Java types
        guard let rawData = platformValue.getData() else {
            return [String: Any]()
        }
        // Convert Kotlin collections to Swift types (same approach as Firestore)
        return deepSwift(value: rawData) ?? [String: Any]()
    }
}

// The gRPC canonical status codes, matching iOS `FunctionsErrorCode`
// (FIRFunctionsErrorCode) and Firestore's `FirestoreErrorCode` 1:1. The Android
// `FirebaseFunctionsException.Code` enum is declared in this exact order, so its
// `ordinal` equals the canonical code value (OK=0 … UNAUTHENTICATED=16).
public enum FunctionsErrorCode: Int {
    case OK = 0
    case cancelled = 1
    case unknown = 2
    case invalidArgument = 3
    case deadlineExceeded = 4
    case notFound = 5
    case alreadyExists = 6
    case permissionDenied = 7
    case resourceExhausted = 8
    case failedPrecondition = 9
    case aborted = 10
    case outOfRange = 11
    case unimplemented = 12
    case `internal` = 13
    case unavailable = 14
    case dataLoss = 15
    case unauthenticated = 16
}

// Matches iOS `FunctionsErrorDomain` (FIRFunctionsErrorDomain) so callers can
// classify Functions failures by domain + code identically on both platforms.
public let FunctionsErrorDomain = "com.firebase.functions"

// Bridge an Android `FirebaseFunctionsException` to an iOS-shaped `NSError`,
// mirroring `asNSError(firestoreException:)`. Firestore's `Code` exposes a
// public `value()`; the Functions `Code` does not, but the enum's declaration
// order is the canonical gRPC order, so `ordinal` is the code value.
fileprivate func asNSError(functionsException: com.google.firebase.functions.FirebaseFunctionsException) -> Error {
    let userInfo: [String: Any] = [:]
    if let detailMessage = functionsException.message {
        userInfo[NSLocalizedFailureReasonErrorKey] = detailMessage
    }
    return NSError(domain: FunctionsErrorDomain, code: functionsException.code.ordinal, userInfo: userInfo)
}

#endif
#endif
