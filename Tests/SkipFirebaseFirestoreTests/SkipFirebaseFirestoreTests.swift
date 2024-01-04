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

// SKIP INSERT: @org.junit.runner.RunWith(androidx.test.ext.junit.runners.AndroidJUnit4::class)
final class SkipFirebaseFirestoreTests: XCTestCase {
    let appName = "SkipFirebaseDemo"

    override func setUp() {
        // the app is registered statically, so check to see if it has been registered
        if let app = FirebaseApp.app(name: appName) {
            app.isDataCollectionDefaultEnabled = false
            return
        }

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
            return XCTFail("no api key set in SKIP_FIREBASE_API_KEY environment")
        }

        if ({ 0 == 1 }())  {
            // these are just to validate the existance of the API
            FirebaseApp.configure()
            FirebaseApp.configure(options: options)
        }

        FirebaseApp.configure(name: appName, options: options)
    }

    #if SKIP
    override func tearDown() throws {
        FirebaseApp.app(name: appName)?.delete()
    }
    #else
    override func tearDown() async throws {
        await FirebaseApp.app(name: appName)?.delete()
    }
    #endif

    func testSkipFirestore() async throws {
        let app: FirebaseApp = try XCTUnwrap(FirebaseApp.app(name: appName))
        app.isDataCollectionDefaultEnabled = false
        XCTAssertEqual(appName, app.name)

        let dbname = "(default)"
        let db: Firestore = Firestore.firestore(app: app, database: dbname)

        let citiesRef = db.collection("cities")

        do {
            let snapshot = try await citiesRef.getDocuments()
            for document in snapshot.documents {
                logger.log("read citiesRef: \(document.documentID) => \(document.data())")
            }
        }

        let bos = citiesRef.document("BOS")


        if ({ 0 == 1 }())  {
            // these are just to validate the existance of the API

            //let _ = await app.delete()

            let _ = citiesRef.document()
            let doc = citiesRef.document("XXX")
            let _ = doc.documentID
            let _ = doc.parent.document().firestore

            try await db.disableNetwork()
            try await db.enableNetwork()

            try await db.clearPersistence()
            try await db.terminate()

            //try await db.terminate()
//            _ = try await db.runTransaction { transaction, errorPtr in
//                transaction.setData([:], forDocument: bos)
//            }

            // test encodable API variants
            //try citiesRef.addDocument(from: ["dict": "value"])
            //try citiesRef.addDocument(from: ["array", "value"])
        }
        try await bos.setData([
            "name": "Boston",
            "state": "MA",
            "country": "USA",
            "capital": false,
            "population": 555000,
            "regions": ["east_coast", "new_england"]
        ])

        let bdoc = try await bos.getDocument()
        XCTAssertEqual("Boston", bdoc.get("name") as? String)

        XCTAssertNotNil(bdoc.get("regions"))

        XCTAssertEqual(["east_coast", "new_england"], bdoc.get("regions") as? [String])

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
    }

    func testFirestoreQuery() async throws {
        let app = try XCTUnwrap(FirebaseApp.app(name: appName))
        app.isDataCollectionDefaultEnabled = false
        XCTAssertEqual(appName, app.name)

        let db = Firestore.firestore(app: app)

        let tblref = db.collection("testFirestoreQuery")
        let doc = try await tblref.addDocument(data: [
            "when": Date.now.timeIntervalSince1970
        ])
        logger.log("testFirestoreQuery: id=\(doc.documentID)")

        #if !SKIP

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
        XCTAssertEqual(2, changes)

        let doc2 = try await doc2Ref.getDocument()
        XCTAssertEqual(when, doc2.get("when") as? Double)
        #endif
    }


    func testSkipBase() throws {
        logger.log("running testSkipBase")
        XCTAssertEqual(1 + 2, 3, "basic test")

        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("SkipBase", testData.testModuleName)
    }

}

struct TestData : Codable, Hashable {
    var testModuleName: String
}
