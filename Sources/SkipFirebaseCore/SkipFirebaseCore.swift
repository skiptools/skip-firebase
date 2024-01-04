// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
public final class FirebaseApp {
    public let app: com.google.firebase.FirebaseApp

    private init(app: com.google.firebase.FirebaseApp) {
        self.app = app
    }

    public var name: String {
        app.name
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

    public static func app(name: String) -> FirebaseApp? {
        guard let app = try? com.google.firebase.FirebaseApp.getInstance(name) else {
            return nil // Firebase throws an exception if getInstance fails, but Swift expects just a nil return
        }
        return FirebaseApp(app: app)
    }

    @available(*, unavailable)
    public func delete() async -> Bool {
        return false
    }
}

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
#endif
