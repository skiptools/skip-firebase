// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import SkipFoundation
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
        if let data = platformValue.getData() {
            return data
        } else {
            assertionFailure("com.google.firebase.functions.HttpsCallableResult returned nil and the Swift API returns a non-nil Any")
        }
    }
}

#endif
#endif
