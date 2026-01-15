// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import Foundation
import OSLog

// https://firebase.google.com/docs/reference/swift/firebasecore/api/reference/Classes/FirebaseApp
// https://firebase.google.com/docs/reference/android/com/google/firebase/FirebaseApp

public final class FirebaseApp: Hashable, KotlinConverting<com.google.firebase.FirebaseApp> {
    public let app: com.google.firebase.FirebaseApp

    public init(app: com.google.firebase.FirebaseApp) {
        self.app = app
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.FirebaseApp {
        app
    }

    public var description: String {
        app.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.app == rhs.app
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(app.hashCode())
    }

    public var name: String {
        app.name
    }

    public var options: FirebaseOptions {
        FirebaseOptions(options: app.options)
    }

    public var isDataCollectionDefaultEnabled: Bool {
        get { app.isDataCollectionDefaultEnabled() }
        set { app.setDataCollectionDefaultEnabled(newValue) }
    }

    public static func configure(name: String, options: FirebaseOptions) {
        _ = com.google.firebase.FirebaseApp.initializeApp(skip.foundation.ProcessInfo.processInfo.androidContext, options.buildOptions(), name)
        return
    }

    public static func configure(options: FirebaseOptions) {
        _ = com.google.firebase.FirebaseApp.initializeApp(skip.foundation.ProcessInfo.processInfo.androidContext, options.buildOptions())
        return
    }

    public static func configure() {
        _ = com.google.firebase.FirebaseApp.initializeApp(skip.foundation.ProcessInfo.processInfo.androidContext)
        return
    }

    public static func app() -> FirebaseApp? {
        do {
            guard let app = try com.google.firebase.FirebaseApp.getInstance() else {
                return nil // Firebase throws an exception if getInstance fails, but Swift expects just a nil return
            }
            return FirebaseApp(app: app)
        } catch {
            android.util.Log.e("SkipFirebaseCore", "error getting FirebaseApp instance", error as? Throwable)
            return nil
        }
    }

    public static func app(name: String) -> FirebaseApp? {
        do {
            guard let app = try? com.google.firebase.FirebaseApp.getInstance(name) else {
                return nil // Firebase throws an exception if getInstance fails, but Swift expects just a nil return
            }
            return FirebaseApp(app: app)
        } catch {
            // the Swift API raises an NSException, which will crash a Swft app
            android.util.Log.e("SkipFirebaseCore", "error getting FirebaseApp instance named '\(name)'", error as? Throwable)
            return nil
        }
    }

    public func delete() -> Bool {
        app.delete()
        return true
    }
}


// https://firebase.google.com/docs/reference/swift/firebasecore/api/reference/Classes/FirebaseOptions
// https://firebase.google.com/docs/reference/android/com/google/firebase/FirebaseOptions

public final class FirebaseOptions {
    public var googleAppID: String
    public var gcmSenderID: String
    public var projectID: String?
    public var storageBucket: String?
    public var apiKey: String?
    public var databaseURL: String?

    public init(googleAppID: String, gcmSenderID: String) {
        self.googleAppID = googleAppID
        self.gcmSenderID = gcmSenderID
    }

    public init(options: com.google.firebase.FirebaseOptions) {
        self.googleAppID = options.applicationId
        self.gcmSenderID = options.gcmSenderId ?? ""
        self.projectID = options.projectId
        self.storageBucket = options.storageBucket
        self.apiKey = options.apiKey
        self.databaseURL = options.databaseUrl
    }

    func buildOptions() -> com.google.firebase.FirebaseOptions {
        var builder = com.google.firebase.FirebaseOptions.Builder()
            .setApplicationId(googleAppID)
            .setGcmSenderId(gcmSenderID)
        if let projectID = projectID {
            builder = builder.setProjectId(projectID)
        }

        if let storageBucket = storageBucket {
            builder = builder.setStorageBucket(storageBucket)
        }

        if let apiKey = apiKey {
            builder = builder.setApiKey(apiKey)
        }

        if let databaseURL = databaseURL {
            builder = builder.setDatabaseUrl(databaseURL)
        }

        return builder.build()
    }
}

// https://firebase.google.com/docs/reference/swift/firebasefirestore/api/reference/Classes/Timestamp
// https://firebase.google.com/docs/reference/android/com/google/firebase/Timestamp

public class Timestamp: Hashable, KotlinConverting<com.google.firebase.Timestamp> {
    public let timestamp: com.google.firebase.Timestamp

    public init(timestamp: com.google.firebase.Timestamp) {
        self.timestamp = timestamp
    }

    public init(date: Date) {
        self.timestamp = com.google.firebase.Timestamp(date.kotlin())
    }

    public init(seconds: Int64, nanoseconds: Int32) {
        self.timestamp = com.google.firebase.Timestamp(seconds, nanoseconds)
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.Timestamp {
        timestamp
    }

    public var description: String {
        timestamp.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.timestamp == rhs.timestamp
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp.hashCode())
    }

    public func dateValue() -> Date {
        Date(platformValue: timestamp.toDate())
    }

    public func toDate() -> Date {
        dateValue()
    }

    public var seconds: Int64 {
        timestamp.seconds
    }

    public var nanoseconds: Int32 {
        timestamp.nanoseconds
    }
}

// MARK: - Kotlin to Swift type conversion helpers

public func deepSwift(value: Any) -> Any {
    if let str = value as? String {
        return str // needed to not be treated as a Collection
    } else if let ts = value as? com.google.firebase.Timestamp {
        return Timestamp(timestamp: ts)
    } else if let map = value as? kotlin.collections.Map<Any, Any> {
        return deepSwift(map: map)
    } else if let collection = value as? kotlin.collections.Collection<Any> {
        return deepSwift(collection: collection)
    } else {
        return value
    }
}

private func deepSwift<T>(map: kotlin.collections.Map<T, Any>) -> Dictionary<T, Any> {
    var dict = Dictionary<T, Any>()
    for (key, value) in map {
        dict[key] = deepSwift(value: value)
    }
    return dict
}

private func deepSwift(collection: kotlin.collections.Collection<Any>) -> Array<Any> {
    var array = Array<Any>()
    for value in collection {
        array.append(deepSwift(value: value))
    }
    return array
}

#endif
#endif
