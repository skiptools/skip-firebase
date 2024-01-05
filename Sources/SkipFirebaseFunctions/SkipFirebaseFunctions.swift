// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
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
}
#endif

//import FirebaseFunctions
//private func demoFirebaseFunctions() async throws {
//    let _ = try await Functions.functions().emulatorOrigin
//}
