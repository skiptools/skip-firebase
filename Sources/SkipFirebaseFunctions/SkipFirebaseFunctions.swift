// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasefunctions/api/reference/Classes/Functions
// https://firebase.google.com/docs/reference/android/com/google/firebase/functions/FirebaseFunctions

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

    public func useEmulator(withHost host: String, port: Int) {
        functions.useEmulator(host, port)
    }

    public func httpsCallable(_ name: String) -> HTTPSCallable {
        HTTPSCallable(functions.getHttpsCallable(name))
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

    public func call(_ data: Any? = nil,
               completion: @escaping (HTTPSCallableResult?,
                                      Error?) -> Void) {
        (data == nil ? platformValue.call() : platformValue.call(data!.kotlin()))
        .addOnSuccessListener { httpsCallableResult in
            completion(HTTPSCallableResult(httpsCallableResult), nil)
        }
        .addOnFailureListener { exception in
            completion(nil, ErrorException(exception))
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
        // WORKAROUND: Access getData() result through a local variable first
        // to avoid potential crashes in Skip's property access transpilation
        let rawData: Any? = platformValue.getData()
        return rawData ?? [String: Any]()
    }
}

#endif
#endif
