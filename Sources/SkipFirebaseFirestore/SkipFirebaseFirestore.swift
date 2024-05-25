// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import Foundation
import SkipFirebaseCore
#if SKIP
// utility to convert from Play services tasks into Kotlin coroutines
// https://developers.google.com/android/guides/tasks#kotlin_coroutine
import kotlinx.coroutines.tasks.await

public final class Firestore: KotlinConverting<com.google.firebase.firestore.FirebaseFirestore> {
    public let store: com.google.firebase.firestore.FirebaseFirestore

    public init(store: com.google.firebase.firestore.FirebaseFirestore) {
        self.store = store
    }

    public var description: String {
        store.toString()
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.FirebaseFirestore {
        store
    }

    public static func firestore(app: FirebaseApp, database: String) -> Firestore {
        return Firestore(store: com.google.firebase.firestore.FirebaseFirestore.getInstance(app.app, database))
    }

    public static func firestore(app: FirebaseApp) -> Firestore {
        return Firestore(store: com.google.firebase.firestore.FirebaseFirestore.getInstance(app.app))
    }

    public static func firestore() -> Firestore {
        return Firestore(store: com.google.firebase.firestore.FirebaseFirestore.getInstance())
    }

    public func collection(_ collectionPath: String) -> CollectionReference {
        CollectionReference(ref: store.collection(collectionPath))
    }

    public func terminate() async {
        store.terminate().await()
    }

    public func clearPersistence() async {
        store.clearPersistence().await()
    }

    public func disableNetwork() async {
        store.disableNetwork().await()
    }

    public func enableNetwork() async {
        store.enableNetwork().await()
    }

    public func loadBundle(_ data: Data) async -> LoadBundleTaskProgress {
        return LoadBundleTaskProgress(progress: store.loadBundle(data.kotlin()).await())
    }

    // TODO: SkipFoundation.InputStream
//    public func loadBundle(_ inputStream: InputStream) async {
//        store.loadBundle(inputStream.kotlin()).await()
//    }

    public func getQuery(named name: String) async -> Query? {
        // SKIP NOWARN
        guard let query = await store.getNamedQuery(name).await() else {
            return nil
        }
        return Query(query: query)
    }
}

/// A FieldPath refers to a field in a document. The path may consist of a single field name (referring to a top level field in the document), or a list of field names (referring to a nested field in the document).
public class FieldPath : Hashable, KotlinConverting<com.google.firebase.firestore.FieldPath> {
    public let fieldPath: com.google.firebase.firestore.FieldPath

    public init(fieldPath: com.google.firebase.firestore.FieldPath) {
        self.fieldPath = fieldPath
    }

    public init(_ fieldNames: [String]) {
        let fnames: kotlin.Array<String> = fieldNames.toList().toTypedArray()
        self.fieldPath = com.google.firebase.firestore.FieldPath.of(*fnames)
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.FieldPath {
        fieldPath
    }

    public var description: String {
        fieldPath.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fieldPath == rhs.fieldPath
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(fieldPath.hashCode())
    }

    /// A special sentinel FieldPath to refer to the ID of a document. It can be used in queries to sort or filter by the document ID.
    public static func documentID() -> FieldPath {
        FieldPath(fieldPath: com.google.firebase.firestore.FieldPath.documentId())
    }
}


public class LoadBundleTaskProgress: KotlinConverting<com.google.firebase.firestore.LoadBundleTaskProgress> {
    public let progress: com.google.firebase.firestore.LoadBundleTaskProgress

    public init(progress: com.google.firebase.firestore.LoadBundleTaskProgress) {
        self.progress = progress
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.LoadBundleTaskProgress {
        progress
    }

    public var description: String {
        progress.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.progress == rhs.progress
    }

    public var totalDocuments: Int {
        progress.totalDocuments
    }

    public var documentsLoaded: Int {
        progress.documentsLoaded
    }

    public var bytesLoaded: Int64 {
        progress.bytesLoaded
    }

    public var totalBytes: Int64 {
        progress.totalBytes
    }

    public var state: LoadBundleTaskState {
        switch progress.taskState {
        case com.google.firebase.firestore.LoadBundleTaskProgress.TaskState.ERROR:
            return LoadBundleTaskState.error
        case com.google.firebase.firestore.LoadBundleTaskProgress.TaskState.RUNNING:
            return LoadBundleTaskState.inProgress
        case com.google.firebase.firestore.LoadBundleTaskProgress.TaskState.SUCCESS:
            return LoadBundleTaskState.success
        }
    }
}

public enum LoadBundleTaskState {
    case error
    case inProgress
    case success
}

/// A query that calculates aggregations over an underlying query.
public class AggregateQuery: KotlinConverting<com.google.firebase.firestore.AggregateQuery> {
    public let query: com.google.firebase.firestore.AggregateQuery

    public init(query: com.google.firebase.firestore.AggregateQuery) {
        self.query = query
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.AggregateQuery {
        query
    }

    public var description: String {
        query.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.query == rhs.query
    }

    public func getAggregation(source: AggregateSource) async throws -> AggregateQuerySnapshot {
        switch source {
        case .server:
            // SKIP NOWARN
            return try await AggregateQuerySnapshot(snap: query.get(com.google.firebase.firestore.AggregateSource.SERVER).await())
        }
    }
}

public class Filter: KotlinConverting<com.google.firebase.firestore.Filter> {
    public let filter: com.google.firebase.firestore.Filter

    public init(filter: com.google.firebase.firestore.Filter = com.google.firebase.firestore.Filter()) {
        self.filter = filter
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.Filter {
        filter
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.filter == rhs.filter
    }
}


public class SnapshotMetadata: KotlinConverting<com.google.firebase.firestore.SnapshotMetadata> {
    public let meta: com.google.firebase.firestore.SnapshotMetadata

    public init(meta: com.google.firebase.firestore.SnapshotMetadata) {
        self.meta = meta
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.SnapshotMetadata {
        meta
    }

    public var description: String {
        meta.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.meta == rhs.meta
    }
}

public class Query: KotlinConverting<com.google.firebase.firestore.Query> {
    public let query: com.google.firebase.firestore.Query

    public init(query: com.google.firebase.firestore.Query) {
        self.query = query
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.Query {
        query
    }

    public var description: String {
        query.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.query == rhs.query
    }

    public func getDocuments() async throws -> QuerySnapshot {
        // SKIP NOWARN
        QuerySnapshot(snap: try await query.get().await())
    }

    public func getDocuments(source: FirestoreSource) async throws -> QuerySnapshot {
        // SKIP NOWARN
        QuerySnapshot(snap: try await query.get(source.source).await())
    }

    public var count: AggregateQuery {
        AggregateQuery(query: query.count())
    }

    public func limit(to count: Int64) -> Query {
        Query(query: query.limit(count))
    }

    public func order(by fieldName: String) -> Query {
        Query(query: query.orderBy(fieldName))
    }

    public func order(by fieldName: String, descending: Bool) -> Query {
        Query(query: query.orderBy(fieldName, descending ? com.google.firebase.firestore.Query.Direction.DESCENDING : com.google.firebase.firestore.Query.Direction.ASCENDING))
    }

    public func whereFilter(_ filter: Filter) -> Query {
        Query(query: query.where(filter.filter))
    }

    public func whereField(_ field: String, in array: [Any]) -> Query {
        Query(query: query.whereIn(field, array.kotlin()))
    }

//    public func whereField(_ field: String, notIn: [Any]) -> Query {
//        Query(query: query.whereNotIn(field, notIn.kotlin()))
//    }

    public func whereField(_ field: String, isEqualTo: Any) -> Query {
        Query(query: query.whereEqualTo(field, isEqualTo.kotlin()))
    }

    public func whereField(_ field: String, isGreaterThan: Any) -> Query {
        Query(query: query.whereGreaterThan(field, isGreaterThan.kotlin()))
    }

    public func whereField(_ field: String, isGreaterThanOrEqualTo: Any) -> Query {
        Query(query: query.whereGreaterThanOrEqualTo(field, isGreaterThanOrEqualTo.kotlin()))
    }

    public func whereField(_ field: String, isNotEqualTo: Any) -> Query {
        Query(query: query.whereNotEqualTo(field, isNotEqualTo.kotlin()))
    }

    public func whereField(_ field: String, isLessThanOrEqualTo: Any) -> Query {
        Query(query: query.whereLessThanOrEqualTo(field, isLessThanOrEqualTo.kotlin()))
    }

    public func whereField(_ field: String, isLessThan: Any) -> Query {
        Query(query: query.whereLessThan(field, isLessThan.kotlin()))
    }

    public func whereField(_ field: String, arrayContains: Any) -> Query {
        Query(query: query.whereArrayContains(field, arrayContains.kotlin()))
    }

    public func whereField(_ field: String, arrayContainsAny: [Any]) -> Query {
        Query(query: query.whereArrayContainsAny(field, arrayContainsAny.kotlin()))
    }


    public func whereField(_ field: FieldPath, in array: [Any]) -> Query {
        Query(query: query.whereIn(field.fieldPath, array.kotlin()))
    }

//    public func whereField(_ field: FieldPath, notIn: [Any]) -> Query {
//        Query(query: query.whereNotIn(field.fieldPath, notIn.kotlin()))
//    }

    public func whereField(_ field: FieldPath, isEqualTo: Any) -> Query {
        Query(query: query.whereEqualTo(field.fieldPath, isEqualTo.kotlin()))
    }

    public func whereField(_ field: FieldPath, isGreaterThan: Any) -> Query {
        Query(query: query.whereGreaterThan(field.fieldPath, isGreaterThan.kotlin()))
    }

    public func whereField(_ field: FieldPath, isGreaterThanOrEqualTo: Any) -> Query {
        Query(query: query.whereGreaterThanOrEqualTo(field.fieldPath, isGreaterThanOrEqualTo.kotlin()))
    }

    public func whereField(_ field: FieldPath, isNotEqualTo: Any) -> Query {
        Query(query: query.whereNotEqualTo(field.fieldPath, isNotEqualTo.kotlin()))
    }

    public func whereField(_ field: FieldPath, isLessThanOrEqualTo: Any) -> Query {
        Query(query: query.whereLessThanOrEqualTo(field.fieldPath, isLessThanOrEqualTo.kotlin()))
    }

    public func whereField(_ field: FieldPath, isLessThan: Any) -> Query {
        Query(query: query.whereLessThan(field.fieldPath, isLessThan.kotlin()))
    }

    public func whereField(_ field: FieldPath, arrayContains: Any) -> Query {
        Query(query: query.whereArrayContains(field.fieldPath, arrayContains.kotlin()))
    }

    public func whereField(_ field: FieldPath, arrayContainsAny: [Any]) -> Query {
        Query(query: query.whereArrayContainsAny(field.fieldPath, arrayContainsAny.kotlin()))
    }

    public func addSnapshotListener(_ listener: @escaping (QuerySnapshot?, Error?) -> ()) -> ListenerRegistration {
        ListenerRegistration(reg: query.addSnapshotListener { snapshot, error in
            let qs: QuerySnapshot? = snapshot == nil ? nil : QuerySnapshot(snap: snapshot!)
            let err: Error? = error?.aserror()
            listener(qs, err)
        })
    }

    public func addSnapshotListener(includeMetadataChanges: Bool, _ listener: @escaping (QuerySnapshot?, Error?) -> ()) -> ListenerRegistration {
        ListenerRegistration(reg: query.addSnapshotListener(includeMetadataChanges ? com.google.firebase.firestore.MetadataChanges.INCLUDE : com.google.firebase.firestore.MetadataChanges.EXCLUDE) { snapshot, error in
            let qs: QuerySnapshot? = snapshot == nil ? nil : QuerySnapshot(snap: snapshot!)
            let err: Error? = error?.aserror()
            listener(qs, err)
        })
    }
}

public class CollectionReference : Query {
    //public let ref: com.google.firebase.firestore.CollectionReference
    public var ref: com.google.firebase.firestore.CollectionReference {
        self.query as! com.google.firebase.firestore.CollectionReference
    }

    public init(ref: com.google.firebase.firestore.CollectionReference) {
        super.init(query: ref)
    }

    public var firestore: Firestore {
        Firestore(store: ref.firestore)
    }

    public var collectionID: String {
        ref.getId()
    }

    public var parent: DocumentReference? {
        guard let parent = ref.parent else { return nil }
        return DocumentReference(ref: parent)
    }

    public var path: String {
        ref.path
    }

    public func document(_ path: String) -> DocumentReference {
        DocumentReference(ref: ref.document(path))
    }

    public func document() -> DocumentReference {
        DocumentReference(ref: ref.document())
    }

    public func addDocument(data: [String: Any]) async throws -> DocumentReference {
        // SKIP NOWARN
        try await DocumentReference(ref: try await ref.add(data.kotlin()).await())
    }
}


public class ListenerRegistration: KotlinConverting<com.google.firebase.firestore.ListenerRegistration> {
    public let reg: com.google.firebase.firestore.ListenerRegistration

    public init(reg: com.google.firebase.firestore.ListenerRegistration) {
        self.reg = reg
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.ListenerRegistration {
        reg
    }

    public var description: String {
        reg.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.reg == rhs.reg
    }

    public func remove() {
        reg.remove()
    }
}

public class Transaction: KotlinConverting<com.google.firebase.firestore.Transaction> {
    public let transaction: com.google.firebase.firestore.Transaction

    public init(transaction: com.google.firebase.firestore.Transaction) {
        self.transaction = transaction
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.Transaction {
        transaction
    }

    public var description: String {
        transaction.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.transaction == rhs.transaction
    }
}

public class QuerySnapshot: KotlinConverting<com.google.firebase.firestore.QuerySnapshot> {
    public let snap: com.google.firebase.firestore.QuerySnapshot

    public init(snap: com.google.firebase.firestore.QuerySnapshot) {
        self.snap = snap
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.QuerySnapshot {
        snap
    }

    public var description: String {
        snap.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.snap == rhs.snap
    }

    public var count: Int {
        snap.size()
    }

    public var isEmpty: Bool {
        snap.isEmpty()
    }

    public var metadata: SnapshotMetadata {
        SnapshotMetadata(snap.metadata)
    }

    public var query: Query {
        Query(query: snap.query)
    }

    public var documents: [QueryDocumentSnapshot] {
        Array(snap.documents.map({ QueryDocumentSnapshot(snapshot: $0 as! com.google.firebase.firestore.QueryDocumentSnapshot) }))
    }

    public var documentChanges: [DocumentChange] {
        Array(snap.getDocumentChanges().map({ DocumentChange(change: $0) }))
    }

    public func documentChanges(includeMetadataChanges: Bool) -> [DocumentChange] {
        Array(snap.getDocumentChanges(includeMetadataChanges
           ? com.google.firebase.firestore.MetadataChanges.INCLUDE
           : com.google.firebase.firestore.MetadataChanges.EXCLUDE)
            .map({ DocumentChange(change: $0) }))
    }
}

public enum AggregateSource {
    case server
}

public enum FirestoreSource {
    case `default`
    case server
    case cache

    public var source: com.google.firebase.firestore.Source {
        switch self {
        case `default`: return com.google.firebase.firestore.Source.DEFAULT
        case cache: return com.google.firebase.firestore.Source.CACHE
        case server: return com.google.firebase.firestore.Source.SERVER
        }
    }
}

public struct AggregateField: KotlinConverting<com.google.firebase.firestore.AggregateField> {
    public let agg: com.google.firebase.firestore.AggregateField

    public init(agg: com.google.firebase.firestore.AggregateField) {
        self.agg = agg
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.AggregateField {
        agg
    }

    public var description: String {
        agg.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.agg == rhs.agg
    }

    public static func count() -> AggregateField {
        AggregateField(agg: com.google.firebase.firestore.AggregateField.count())
    }

    public static func average(_ fieldName: String) -> AggregateField {
        AggregateField(agg: com.google.firebase.firestore.AggregateField.average(fieldName))
    }

    public static func average(_ field: FieldPath) -> AggregateField {
        AggregateField(agg: com.google.firebase.firestore.AggregateField.average(field.fieldPath))
    }

    public static func sum(_ fieldName: String) -> AggregateField {
        AggregateField(agg: com.google.firebase.firestore.AggregateField.sum(fieldName))
    }

    public static func sum(_ field: FieldPath) -> AggregateField {
        AggregateField(agg: com.google.firebase.firestore.AggregateField.sum(field.fieldPath))
    }
}

public class AggregateQuerySnapshot: KotlinConverting<com.google.firebase.firestore.AggregateQuerySnapshot> {
    public let snap: com.google.firebase.firestore.AggregateQuerySnapshot

    public init(snap: com.google.firebase.firestore.AggregateQuerySnapshot) {
        self.snap = snap
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.AggregateQuerySnapshot {
        snap
    }

    public var description: String {
        snap.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.snap == rhs.snap
    }

    public var count: Int64 {
        snap.count
    }

    public var query: AggregateQuery {
        AggregateQuery(query: snap.query)
    }

    public func get(_ aggregateField: AggregateField) -> Any? {
        guard let value = snap.get(aggregateField.agg) else {
            return nil
        }
        return deepSwift(value: value)
    }
}

public class DocumentChange: KotlinConverting<com.google.firebase.firestore.DocumentChange> {
    public let change: com.google.firebase.firestore.DocumentChange

    public init(change: com.google.firebase.firestore.DocumentChange) {
        self.change = change
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.DocumentChange {
        change
    }

    public var description: String {
        change.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.change == rhs.change
    }

    public var document: QueryDocumentSnapshot {
        QueryDocumentSnapshot(snapshot: change.document)
    }

    public var type: DocumentChangeType {
        switch change.type {
        case com.google.firebase.firestore.DocumentChange.Type.ADDED: 
            return DocumentChangeType.added
        case com.google.firebase.firestore.DocumentChange.Type.MODIFIED: 
            return DocumentChangeType.modified
        case com.google.firebase.firestore.DocumentChange.Type.REMOVED: 
            return DocumentChangeType.removed
        }
    }
}

public enum DocumentChangeType {
    case added
    case modified
    case removed
}

public class DocumentSnapshot: KotlinConverting<com.google.firebase.firestore.DocumentSnapshot> {
    public let doc: com.google.firebase.firestore.DocumentSnapshot

    public init(doc: com.google.firebase.firestore.DocumentSnapshot) {
        self.doc = doc
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.DocumentSnapshot {
        doc
    }

    public var description: String {
        doc.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.doc == rhs.doc
    }

    public var documentID: String {
        doc.getId()
    }

    public func data() -> [String: Any] {
        if let data = doc.getData() {
            return deepSwift(map: data)
        } else {
            return [:]
        }
    }

    public func get(_ fieldName: String) -> Any? {
        guard let value = doc.get(fieldName) else {
            return nil
        }
        return deepSwift(value: value)
    }
}

public class QueryDocumentSnapshot : DocumentSnapshot {
    public var snapshot: com.google.firebase.firestore.QueryDocumentSnapshot {
        doc as! com.google.firebase.firestore.QueryDocumentSnapshot
    }

    public init(snapshot: com.google.firebase.firestore.QueryDocumentSnapshot) {
        super.init(doc: snapshot)
    }

    public var reference: DocumentReference {
        DocumentReference(ref: snapshot.reference)
    }
}

public class DocumentReference: KotlinConverting<com.google.firebase.firestore.DocumentReference> {
    public let ref: com.google.firebase.firestore.DocumentReference

    public init(ref: com.google.firebase.firestore.DocumentReference) {
        self.ref = ref
    }

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.DocumentReference {
        ref
    }

    public var description: String {
        ref.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.ref == rhs.ref
    }

    public var firestore: Firestore {
        Firestore(store: ref.firestore)
    }

    public func getDocument() async throws -> DocumentSnapshot {
        // SKIP NOWARN
        DocumentSnapshot(doc: try await ref.get().await())
    }

    public var parent: CollectionReference {
        CollectionReference(ref: ref.parent)
    }

    public var documentID: String {
        ref.getId()
    }

    public var path: String {
        ref.path
    }

    public func delete() async throws {
        // SKIP NOWARN
        try await ref.delete().await()
    }

    public func setData(_ keyValues: [String: Any], merge: Bool = false) async throws {
        if merge == true {
            // SKIP NOWARN
            try await ref.set(keyValues.kotlin(), com.google.firebase.firestore.SetOptions.merge())
        } else {
            // SKIP NOWARN
            try await ref.set(keyValues.kotlin())
        }
    }

    public func updateData(_ keyValues: [String: Any]) async throws {
        // SKIP NOWARN
        try await ref.update(keyValues.kotlin() as! Map<String, Any>)
    }
}

public class Timestamp: KotlinConverting<com.google.firebase.Timestamp> {
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

    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.Timestamp {
        timestamp
    }

    public var description: String {
        timestamp.toString()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.timestamp == rhs.timestamp
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(timestamp)
    }
}

// MARK: Utilies for converting between Swift and Kotlin types

fileprivate func deepSwift(value: Any) -> Any {
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

fileprivate func deepSwift<T>(map: kotlin.collections.Map<T, Any>) -> Dictionary<T, Any> {
    var dict = Dictionary<T, Any>()
    for (key, value) in map {
        dict[key] = deepSwift(value: value)
    }
    return dict
}

fileprivate func deepSwift(collection: kotlin.collections.Collection<Any>) -> Array<Any> {
    var array = Array<Any>()
    for value in collection {
        array.append(deepSwift(value: value))
    }
    return array
}

#endif
