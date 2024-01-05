// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class FirebaseFunctions {
    public let functions: com.google.firebase.functions.FirebaseFunctions

    public init(functions: com.google.firebase.functions.FirebaseFunctions) {
        self.functions = functions
    }
}
#endif
