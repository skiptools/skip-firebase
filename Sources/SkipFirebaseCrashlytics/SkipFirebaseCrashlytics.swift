// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseCrashlytics)
@_exported import FirebaseCrashlytics
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasecrashlytics/api/reference/Classes/Crashlytics
// https://firebase.google.com/docs/reference/android/com/google/firebase/crashlytics/FirebaseCrashlytics

public final class Crashlytics {
    public let _crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics

    public init(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics) {
        self._crashlytics = crashlytics
    }

    public static func crashlytics() -> Crashlytics {
        Crashlytics(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics.getInstance())
    }

//    public static func crashlytics(app: FirebaseApp) -> Crashlytics {
//        Crashlytics(crashlytics: com.google.firebase.crashlytics.FirebaseCrashlytics.getInstance(app.app))
//    }

    public func log(_ message: String) {
        _crashlytics.log(message)
    }

    @available(*, unavailable)
    public func logWithFormat(_ format: String, _ args: Any...) {
        fatalError("Unavailable")
    }

    @available(*, unavailable)
    public func logWithFormat(_ format: String, arguments: [Any]) {
        fatalError("Unavailable")
    }

    public func setCustomValue(_ value: Any?, forKey key: String) {
        guard let value else {
            _crashlytics.setCustomKey(key, "nil")
            return
        }

        if let bool = value as? Bool {
            _crashlytics.setCustomKey(key, bool)
        } else if let int = value as? Int {
            _crashlytics.setCustomKey(key, int)
        } else if let int64 = value as? Int64 {
            _crashlytics.setCustomKey(key, int64)
        } else if let float = value as? Float {
            _crashlytics.setCustomKey(key, float)
        } else if let double = value as? Double {
            _crashlytics.setCustomKey(key, double)
        } else if let string = value as? String {
            _crashlytics.setCustomKey(key, string)
        } else {
            _crashlytics.setCustomKey(key, "\(value)")
        }
    }

    public func setCustomKeysAndValues(_ keysAndValues: [String: Any]) {
        for (key, value) in keysAndValues {
            setCustomValue(value, forKey: key)
        }
    }

    public func setUserID(_ userID: String?) {
        _crashlytics.setUserId(userID ?? "")
    }

    public func didCrashDuringPreviousExecution() -> Bool {
        _crashlytics.didCrashOnPreviousExecution()
    }

    public func setCrashlyticsCollectionEnabled(_ enabled: Bool) {
        _crashlytics.setCrashlyticsCollectionEnabled(enabled)
    }

    public func isCrashlyticsCollectionEnabled() -> Bool {
        _crashlytics.isCrashlyticsCollectionEnabled()
    }

    public func checkForUnsentReports() async throws -> Bool {
        let result = _crashlytics.checkForUnsentReports().await()
        return result as? Bool ?? false
    }

    public func checkForUnsentReports(completion: @escaping (Bool) -> Void) {
        Task {
            do {
                completion(try await checkForUnsentReports())
            } catch {
                completion(false)
            }
        }
    }

    public func checkForUnsentReportsWithCompletion(_ completion: @escaping (Bool) -> Void) {
        checkForUnsentReports(completion: completion)
    }

    // Android does not have an updateable report object API.
    @available(*, unavailable)
    public func checkAndUpdateUnsentReportsWithCompletion(_ completion: @escaping (Any?) -> Void) {
        fatalError()
    }

    public func sendUnsentReports() {
        _crashlytics.sendUnsentReports()
    }

    public func deleteUnsentReports() {
        _crashlytics.deleteUnsentReports()
    }

    public func record(error: Error, userInfo: [String: Any]? = nil) {
        let throwable: Throwable
        if let throwableError = error as? Throwable {
            throwable = throwableError
        } else {
            let message: String
            if let debug = error as? CustomDebugStringConvertible {
                message = debug.debugDescription
            } else {
                message = error.localizedDescription
            }
            do {
                throw ErrorException(message)
            } catch {
                throwable = error as! Throwable
            }
        }

        if let userInfo, !userInfo.isEmpty {
            _crashlytics.recordException(throwable, customKeysAndValues(userInfo))
        } else {
            _crashlytics.recordException(throwable)
        }
    }

    public func recordExceptionModel(_ exceptionModel: FIRExceptionModel) {
        _crashlytics.recordException(exceptionModel.toThrowable())
    }

    private func customKeysAndValues(_ values: [String: Any]) -> com.google.firebase.crashlytics.CustomKeysAndValues {
        let builder = com.google.firebase.crashlytics.CustomKeysAndValues.Builder()
        for (key, value) in values {
            if let bool = value as? Bool {
                builder.putBoolean(key, bool)
            } else if let int = value as? Int {
                builder.putInt(key, int)
            } else if let int64 = value as? Int64 {
                builder.putLong(key, int64)
            } else if let float = value as? Float {
                builder.putFloat(key, float)
            } else if let double = value as? Double {
                builder.putDouble(key, double)
            } else if let string = value as? String {
                builder.putString(key, string)
            } else {
                builder.putString(key, "\(value)")
            }
        }
        return builder.build()
    }
}

public struct FIRExceptionModel {
    public let name: String
    public let reason: String
    public let stackTrace: [FIRStackFrame]

    public init(name: String, reason: String, stackTrace: [FIRStackFrame] = []) {
        self.name = name
        self.reason = reason
        self.stackTrace = stackTrace
    }

    func toThrowable() -> Throwable {
        let throwable = Throwable(message: "\(name): \(reason)")
        let elements = stackTrace.map { $0.toStackTraceElement() }.toList().toTypedArray()
        throwable.setStackTrace(elements)
        return throwable
    }
}

public struct FIRStackFrame {
    public let symbol: String
    public let file: String?
    public let line: Int
    public let className: String

    public init(symbol: String, file: String? = nil, line: Int = -1, className: String = "Swift") {
        self.symbol = symbol
        self.file = file
        self.line = line
        self.className = className
    }

    fileprivate func toStackTraceElement() -> java.lang.StackTraceElement {
        java.lang.StackTraceElement(className, symbol, file, line)
    }
}
#endif
#endif
