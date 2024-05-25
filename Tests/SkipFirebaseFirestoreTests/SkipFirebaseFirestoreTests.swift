// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import XCTest
import OSLog
import Foundation

#if !SKIP
import FirebaseCore
import FirebaseFirestore
#else
import SkipFirebaseCore
import SkipFirebaseFirestore
#endif

let logger: Logger = Logger(subsystem: "SkipBase", category: "Tests")

var appName: String = "SkipFirebaseDemo"

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
// SKIP INSERT: @org.robolectric.annotation.LooperMode(org.robolectric.annotation.LooperMode.Mode.PAUSED)
final class SkipFirebaseFirestoreTests: XCTestCase {

    /// App needs to be initialized in setUp and cleaned up in tearDown
    fileprivate var app: FirebaseApp!

    // runtestFirestoreBundles$SkipFirebaseFirestore_debugUnitTest kotlinx.coroutines.test.UncompletedCoroutinesError: After waiting for 10s, the test coroutine is not completing, there were active child jobs: [DispatchedCoroutine{Active}@3816ef2f]
    // Suppressed: org.robolectric.android.internal.AndroidTestEnvironment$UnExecutedRunnablesException: Main looper has queued unexecuted runnables. This might be the cause of the test failure. You might need a shadowOf(Looper.getMainLooper()).idle() call

    override func setUp() {
        // this is generally loaded from the system's GoogleService-Info.plist / google-services.json using the default constructor, but for the sake of the test case we manually set it up here
        let options = FirebaseOptions(googleAppID: "1:599015466373:ios:918f07f9e07f56b03890ec", gcmSenderID: "599015466373")

        XCTAssertNil(options.apiKey)
        XCTAssertNil(options.projectID)
        XCTAssertNil(options.storageBucket)
        XCTAssertNil(options.databaseURL)
        #if !SKIP // TODO: add options to FirebaseOptions
        XCTAssertNil(options.appGroupID)
        XCTAssertNil(options.clientID)
        XCTAssertNil(options.deepLinkURLScheme)
        #endif

        options.projectID = "skip-firebase-demo"
        options.storageBucket = "skip-firebase-demo.appspot.com"

        options.apiKey = ProcessInfo.processInfo.environment["SKIP_FIREBASE_API_KEY"] ?? String(data: Data(base64Encoded: "QUl6YVN5QzV2bDFNYUc2S0hMOU15V1kyWGhxTHZCdVJsVEhrc3lR")!, encoding: .utf8)
        if options.apiKey == nil {
            fatalError("no api key set in SKIP_FIREBASE_API_KEY environment")
        }

        if ({ 0 == 1 }())  {
            // these are just to validate the existance of the API
            FirebaseApp.configure()
            FirebaseApp.configure(options: options)
        }

        FirebaseApp.configure(name: appName, options: options)

        // the app is registered statically, so check to see if it has been registered
        if let app = FirebaseApp.app(name: appName) {
            app.isDataCollectionDefaultEnabled = false
            self.app = app
        } else {
            fatalError("unable to load FirebaseApp.app(name: \"\(appName)\")")
        }
    }

    #if SKIP
    override func tearDown() throws {
        FirebaseApp.app(name: appName)?.delete()

        // needed or else: Suppressed: org.robolectric.android.internal.AndroidTestEnvironment$UnExecutedRunnablesException: Main looper has queued unexecuted runnables. This might be the cause of the test failure. You might need a shadowOf(Looper.getMainLooper()).idle() call.
        org.robolectric.Shadows.shadowOf(android.os.Looper.getMainLooper()).idle()
    }
    #else
    override func tearDown() async throws {
        await FirebaseApp.app(name: appName)?.delete()
    }
    #endif

    /// This is never invoked, it is just to validate API parity
    private func validateFirebaseWrapperAPI() async throws {
        let db: Firestore = Firestore.firestore(app: self.app)

        let colRef: CollectionReference = db.collection("")
        let _: Firestore = colRef.firestore
        let _: String = colRef.collectionID
        let dref: DocumentReference? = colRef.parent
        let _ = dref?.path
        let _ = dref?.parent

        let _: String = colRef.path
        let _ = colRef.document()
        let _ = colRef.collectionID
        let _ = colRef.parent
        let _ = colRef.path
        try await colRef.addDocument(data: ["x": 0.0])

        let aq: AggregateQuery = colRef.count
        let _ = aq.query

        let aqs: AggregateQuerySnapshot = try await aq.getAggregation(source: AggregateSource.server)
        let _ = aqs.count
        let _: AggregateQuery = aqs.query

        let af: AggregateField = AggregateField.average("ABC")
        let _ = aqs.get(af)


        let _: Query = colRef.limit(to: 10)

        let _: Query = colRef.order(by: "x")
        let _: Query = colRef.order(by: "x", descending: true)

        let _: Query = colRef.whereFilter(Filter())

        let _: Query = colRef.whereField("x", in: ["x"])
        //let _: Query = colRef.whereField("x", notIn: ["x"])
        let _: Query = colRef.whereField("x", isEqualTo: "x")
        let _: Query = colRef.whereField("x", arrayContains: "x")
        let _: Query = colRef.whereField("x", arrayContainsAny: ["x"])
        let _: Query = colRef.whereField("x", isGreaterThan: "x")
        let _: Query = colRef.whereField("x", isGreaterThanOrEqualTo: "x")
        let _: Query = colRef.whereField("x", isNotEqualTo: "x")
        let _: Query = colRef.whereField("x", isLessThanOrEqualTo: "x")
        let _: Query = colRef.whereField("x", isLessThan: "x")

        let fp: FieldPath = FieldPath(["x", "y"])
        let _: Query = colRef.whereField(fp, in: ["x"])
        //let _: Query = colRef.whereField(fp, notIn: ["x"])
        let _: Query = colRef.whereField(fp, isEqualTo: "x")
        let _: Query = colRef.whereField(fp, arrayContains: "x")
        let _: Query = colRef.whereField(fp, arrayContainsAny: ["x"])
        let _: Query = colRef.whereField(fp, isGreaterThan: "x")
        let _: Query = colRef.whereField(fp, isGreaterThanOrEqualTo: "x")
        let _: Query = colRef.whereField(fp, isNotEqualTo: "x")
        let _: Query = colRef.whereField(fp, isLessThanOrEqualTo: "x")
        let _: Query = colRef.whereField(fp, isLessThan: "x")


        let listenerRef: ListenerRegistration = colRef.addSnapshotListener { snap, error in
            if let snap = snap {
                let _: [DocumentChange] = snap.documentChanges
                let _: [DocumentChange] = snap.documentChanges(includeMetadataChanges: true)
                let _: [QueryDocumentSnapshot] = snap.documents
                let _: Query = snap.query
                let _: Int = snap.count
                let _: Bool = snap.isEmpty
                let _: SnapshotMetadata = snap.metadata
            }
        }
        listenerRef.remove()

        let docRef: DocumentReference = colRef.document("")
        let _: Firestore = docRef.firestore
        let _: String = docRef.documentID
        let _: String = docRef.path
        let _: CollectionReference = docRef.parent

        try await db.disableNetwork()
        try await db.enableNetwork()

        try await db.clearPersistence()
        try await db.terminate()

        //try await db.terminate()
        //_ = try await db.runTransaction { transaction, errorPtr in
        //    transaction.setData([:], forDocument: bos)
        //}

        // test encodable API variants
        //try citiesRef.addDocument(from: ["dict": "value"])
        //try citiesRef.addDocument(from: ["array", "value"])
    }

    func testFirestore() async throws {
        XCTAssertEqual(appName, self.app.name)

        let dbname = "(default)"
        let db: Firestore = Firestore.firestore(app: self.app, database: dbname)

        let citiesRef = db.collection("cities")

        do {
            let snapshot = try await citiesRef.getDocuments()
            for document in snapshot.documents {
                logger.log("read citiesRef: \(document.documentID) => \(document.data())")
            }
        }

        XCTAssertEqual(Timestamp(date: Date(timeIntervalSince1970: 12345)), Timestamp(seconds: 12345, nanoseconds: 0))

        let bos = citiesRef.document("BOS")

        try await bos.setData([
            "name": "Boston",
            "state": "MA",
            "country": "USA",
            "capital": false,
            "population": 555000,
            "regions": ["east_coast", "new_england"],
            "time": Timestamp(date: Date(timeIntervalSince1970: 1234))
        ])

        let bdoc = try await bos.getDocument()
        XCTAssertEqual("Boston", bdoc.get("name") as? String)

        XCTAssertNotNil(bdoc.get("regions"))

        XCTAssertEqual(["east_coast", "new_england"], bdoc.get("regions") as? [String])

        XCTAssertNotNil(bdoc.get("time"))
        XCTAssertEqual(Timestamp(date: Date(timeIntervalSince1970: 1234)), bdoc.get("time") as? Timestamp)

        XCTAssertEqual(555000, bdoc.get("population") as? Int64)
        try await bos.updateData(["population": 675000])

        XCTAssertEqual(555000, bdoc.get("population") as? Int64)
        let bdoc2 = try await bos.getDocument()
        XCTAssertEqual(675000, bdoc2.get("population") as? Int64)

        try await citiesRef.document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA",
            "capital": false,
            "population": 3900000,
            "regions": ["west_coast", "socal"]
        ])
        try await citiesRef.document("DC").setData([
            "name": "Washington D.C.",
            "country": "USA",
            "capital": true,
            "population": 680000,
            "regions": ["east_coast"]
        ])
        try await citiesRef.document("TOK").setData([
            "name": "Tokyo",
            "country": "Japan",
            "capital": true,
            "population": 9000000,
            "regions": ["kanto", "honshu"]
        ])
        try await citiesRef.document("BJ").setData([
            "name": "Beijing",
            "country": "China",
            "capital": true,
            "population": 21500000,
            "regions": ["jingjinji", "hebei"]
        ])

        do {
            let snapshot = try await citiesRef.getDocuments()
            for document in snapshot.documents {
                logger.log("read citiesRef: \(document.documentID) => \(document.data())")
            }
        }

        // follow-on test since running multiple separate firestore tests in a single case seems to fail (possibly due to re-configuration of the FirebaseApp app)
        //try await XXXtestFirestoreQuery()
    }

    func XXXtestFirestoreQuery() async throws {
        XCTAssertEqual(appName, self.app.name)

        let db = Firestore.firestore(app: self.app)

        let tblref = db.collection("testFirestoreQuery")
        let doc = try await tblref.addDocument(data: [
            "when": Date.now.timeIntervalSince1970
        ])
        logger.log("testFirestoreQuery: id=\(doc.documentID)")

        var changes = 0
        let reg = tblref.addSnapshotListener(includeMetadataChanges: true, listener: { querySnapshot, error in
            changes += 1
            guard let querySnapshot else {
                return XCTFail("no query snapshot")
            }
            logger.log("querySnapshot: \(querySnapshot)")
            for diff in querySnapshot.documentChanges {
                logger.log("  diff: \(diff)")
            }
        })
        defer { reg.remove() }

        let when = Date.now.timeIntervalSince1970
        XCTAssertEqual(0, changes)

        let doc2Ref = try await tblref.addDocument(data: [
            "when": when
        ])
        //XCTAssertEqual(2, changes)

        let doc2 = try await doc2Ref.getDocument()
        XCTAssertEqual(when, doc2.get("when") as? Double)

        //try await XXXtestFirestoreBundles()
    }

    func XXXtestFirestoreBundles() async throws {

        // see Resources/ firestore_bundle-1.json, firestore_bundle-2.json, firestore_bundle-3.json
        let bundle1 = try Data(contentsOf: XCTUnwrap(Bundle.module.url(forResource: "firestore_bundle-1", withExtension: "json")))

        let data = bundle1


        // the name of the app must match the bundle to be loaded, or else:
        // 10.19.1 - [FirebaseFirestore][I-FST000001] Failed to GetNextElement() from bundle with error Resource name is not valid for current instance: projects/react-native-firebase-testing/databases/(default)/documents

        let appName = "react-native-firebase-testing"

        let options = FirebaseOptions(googleAppID: self.app.options.googleAppID, gcmSenderID: self.app.options.gcmSenderID)
        options.projectID = appName
        options.storageBucket = appName + ".appspot.com"

        options.apiKey = self.app.options.apiKey
        if options.apiKey == nil {
            fatalError("no api key set in SKIP_FIREBASE_API_KEY environment")
        }

        FirebaseApp.configure(name: appName, options: options)

        // the app is registered statically, so check to see if it has been registered
        let cacheApp = try XCTUnwrap(FirebaseApp.app(name: appName))

        let store = Firestore.firestore(app: cacheApp)

        let progress: LoadBundleTaskProgress = try await store.loadBundle(data)
        XCTAssertEqual(12, progress.totalDocuments)

        let cacheQuery = await store.getQuery(named: "named-bundle-test-1")
        // SKIP NOWARN
        let docs = try await XCTUnwrap(cacheQuery).getDocuments(source: FirestoreSource.cache)
        XCTAssertEqual(12, docs.count)

        // SKIP NOWARN
        await cacheApp.delete()
    }
}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
