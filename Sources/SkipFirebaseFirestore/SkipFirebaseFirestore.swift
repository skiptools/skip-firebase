// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if !SKIP_BRIDGE
#if SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

public final class Firestore: KotlinConverting<com.google.firebase.firestore.FirebaseFirestore> {
    // SKIP @nobridge
    public let store: com.google.firebase.firestore.FirebaseFirestore

    // SKIP @nobridge
    public init(store: com.google.firebase.firestore.FirebaseFirestore) {
        self.store = store
    }

    public var description: String {
        store.toString()
    }

    // SKIP @nobridge
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
        guard let query = store.getNamedQuery(name).await() else {
            return nil
        }
        return Query(query: query)
    }

    public func collectionGroup(collectionId: String) -> Query {
        return Query(query: store.collectionGroup(collectionId)) 
    }

    public func batch() -> WriteBatch {
        return WriteBatch(batch: store.batch())
    }

    public func useEmulator(withHost host: String, port: Int) {
        store.useEmulator(host, port)
    }
}

/// A FieldPath refers to a field in a document. The path may consist of a single field name (referring to a top level field in the document), or a list of field names (referring to a nested field in the document).
public class FieldPath : Hashable, KotlinConverting<com.google.firebase.firestore.FieldPath> {
    // SKIP @nobridge
    public let fieldPath: com.google.firebase.firestore.FieldPath

    // SKIP @nobridge
    public init(fieldPath: com.google.firebase.firestore.FieldPath) {
        self.fieldPath = fieldPath
    }

    public init(_ fieldNames: [String]) {
        let fnames: kotlin.Array<String> = fieldNames.toList().toTypedArray()
        self.fieldPath = com.google.firebase.firestore.FieldPath.of(*fnames)
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let progress: com.google.firebase.firestore.LoadBundleTaskProgress

    // SKIP @nobridge
    public init(progress: com.google.firebase.firestore.LoadBundleTaskProgress) {
        self.progress = progress
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let query: com.google.firebase.firestore.AggregateQuery

    // SKIP @nobridge
    public init(query: com.google.firebase.firestore.AggregateQuery) {
        self.query = query
    }

    // SKIP @nobridge
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
            return AggregateQuerySnapshot(snap: query.get(com.google.firebase.firestore.AggregateSource.SERVER).await())
        }
    }
}

public class Filter: KotlinConverting<com.google.firebase.firestore.Filter> {
    // SKIP @nobridge
    public let filter: com.google.firebase.firestore.Filter

    // SKIP @nobridge
    public init(filter: com.google.firebase.firestore.Filter = com.google.firebase.firestore.Filter()) {
        self.filter = filter
    }

    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.Filter {
        filter
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.filter == rhs.filter
    }
}

public class SnapshotMetadata: KotlinConverting<com.google.firebase.firestore.SnapshotMetadata> {
    // SKIP @nobridge
    public let meta: com.google.firebase.firestore.SnapshotMetadata

    // SKIP @nobridge
    public init(meta: com.google.firebase.firestore.SnapshotMetadata) {
        self.meta = meta
    }

    // SKIP @nobridge
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.SnapshotMetadata {
        meta
    }

    public var description: String {
        meta.toString()
    }

    public var hasPendingWrites: Bool {
        meta.hasPendingWrites()
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.meta == rhs.meta
    }
}

public class Query: KotlinConverting<com.google.firebase.firestore.Query> {
    // SKIP @nobridge
    public let query: com.google.firebase.firestore.Query

    // SKIP @nobridge
    public init(query: com.google.firebase.firestore.Query) {
        self.query = query
    }

    // SKIP @nobridge
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
        QuerySnapshot(snap: query.get().await())
    }

    public func getDocuments(source: FirestoreSource) async throws -> QuerySnapshot {
        QuerySnapshot(snap: query.get(source.source).await())
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

    public func start(afterDocument: DocumentSnapshot) -> Query {
        Query(query: query.startAfter(afterDocument.kotlin()))
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
    // SKIP @nobridge
    public var ref: com.google.firebase.firestore.CollectionReference {
        self.query as! com.google.firebase.firestore.CollectionReference
    }

    // SKIP @nobridge
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
        DocumentReference(ref: ref.add(data.kotlin()).await())
    }
}

public class ListenerRegistration: KotlinConverting<com.google.firebase.firestore.ListenerRegistration> {
    // SKIP @nobridge
    public let reg: com.google.firebase.firestore.ListenerRegistration

    // SKIP @nobridge
    public init(reg: com.google.firebase.firestore.ListenerRegistration) {
        self.reg = reg
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let transaction: com.google.firebase.firestore.Transaction

    // SKIP @nobridge
    public init(transaction: com.google.firebase.firestore.Transaction) {
        self.transaction = transaction
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let snap: com.google.firebase.firestore.QuerySnapshot

    // SKIP @nobridge
    public init(snap: com.google.firebase.firestore.QuerySnapshot) {
        self.snap = snap
    }

    // SKIP @nobridge
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

    // SKIP @nobridge
    public var source: com.google.firebase.firestore.Source {
        switch self {
        case `default`: return com.google.firebase.firestore.Source.DEFAULT
        case cache: return com.google.firebase.firestore.Source.CACHE
        case server: return com.google.firebase.firestore.Source.SERVER
        }
    }
}

public struct AggregateField: KotlinConverting<com.google.firebase.firestore.AggregateField> {
    // SKIP @nobridge
    public let agg: com.google.firebase.firestore.AggregateField

    // SKIP @nobridge
    public init(agg: com.google.firebase.firestore.AggregateField) {
        self.agg = agg
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let snap: com.google.firebase.firestore.AggregateQuerySnapshot

    // SKIP @nobridge
    public init(snap: com.google.firebase.firestore.AggregateQuerySnapshot) {
        self.snap = snap
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let change: com.google.firebase.firestore.DocumentChange

    // SKIP @nobridge
    public init(change: com.google.firebase.firestore.DocumentChange) {
        self.change = change
    }

    // SKIP @nobridge
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
    // SKIP @nobridge
    public let doc: com.google.firebase.firestore.DocumentSnapshot

    // SKIP @nobridge
    public init(doc: com.google.firebase.firestore.DocumentSnapshot) {
        self.doc = doc
    }

    // SKIP @nobridge
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
    
    public var exists: Bool {
        doc.exists()
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
    // SKIP @nobridge
    public var snapshot: com.google.firebase.firestore.QueryDocumentSnapshot {
        doc as! com.google.firebase.firestore.QueryDocumentSnapshot
    }

    // SKIP @nobridge
    public init(snapshot: com.google.firebase.firestore.QueryDocumentSnapshot) {
        super.init(doc: snapshot)
    }

    public var reference: DocumentReference {
        DocumentReference(ref: snapshot.reference)
    }
}

public class DocumentReference: KotlinConverting<com.google.firebase.firestore.DocumentReference> {
    // SKIP @nobridge
    public let ref: com.google.firebase.firestore.DocumentReference

    // SKIP @nobridge
    public init(ref: com.google.firebase.firestore.DocumentReference) {
        self.ref = ref
    }

    // SKIP @nobridge
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
        DocumentSnapshot(doc: ref.get().await())
    }

    public func getDocument(completion: (_ snapshot: DocumentSnapshot?, _ error: (any Error)?) -> Void) {
        ref.get().addOnSuccessListener { documentSnapshot in
            completion(DocumentSnapshot(doc: documentSnapshot), nil)
        }
        .addOnFailureListener { exception in
            completion(nil, ErrorException(exception))
        }
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
        ref.delete().await()
    }

    public func setData(_ keyValues: [String: Any], merge: Bool = false) async throws {
        if merge == true {
            ref.set(keyValues.kotlin(), com.google.firebase.firestore.SetOptions.merge())
        } else {
            ref.set(keyValues.kotlin())
        }
    }

    public func updateData(_ keyValues: [String: Any]) async throws {
        ref.update(keyValues.kotlin() as! Map<String, Any>)
    }

    public func collection(_ collectionPath: String) -> CollectionReference {
        CollectionReference(ref: ref.collection(collectionPath))
    }
}

public class Timestamp: Hashable, KotlinConverting<com.google.firebase.Timestamp> {
    // SKIP @nobridge
    public let timestamp: com.google.firebase.Timestamp

    // SKIP @nobridge
    public init(timestamp: com.google.firebase.Timestamp) {
        self.timestamp = timestamp
    }

    public init(date: Date) {
        self.timestamp = com.google.firebase.Timestamp(date.kotlin())
    }

    public init(seconds: Int64, nanoseconds: Int32) {
        self.timestamp = com.google.firebase.Timestamp(seconds, nanoseconds)
    }

    // SKIP @nobridge
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

public class WriteBatch {
    // SKIP @nobridge
    public let batch: com.google.firebase.firestore.WriteBatch

    // SKIP @nobridge
    public init(batch: com.google.firebase.firestore.WriteBatch) {
        self.batch = batch
    }

    public func commit() async throws {
        batch.commit().await()
    }

    public func deleteDocument(_ document: DocumentReference) -> WriteBatch {
        let newBatch = batch.delete(document.ref)
        return WriteBatch(batch: newBatch)
    }

    public func setData( _ data: [String : Any], forDocument document: DocumentReference) -> WriteBatch {
        let newBatch = batch.set(document.ref, data.kotlin())
        return WriteBatch(batch: newBatch)
    }
    
    public func setData(_ data: [String : Any], forDocument document: DocumentReference, mergeFields: [String]) -> WriteBatch {
        let newBatch = batch.set(document.ref, data.kotlin(), com.google.firebase.firestore.SetOptions.mergeFields(mergeFields.toList()))
        return WriteBatch(batch: newBatch)
    }

    public func updateData(_ fields: [AnyHashable : Any], forDocument document: DocumentReference) -> WriteBatch {
        let newBatch = batch.update(document.ref, fields.kotlin() as! Map<String, Any>)
        return WriteBatch(batch: newBatch)
    }
}

public class FieldValue {
    // SKIP @nobridge
    public class func arrayRemove(_ elements: [Any]) -> com.google.firebase.firestore.FieldValue {
        let elementsArray: kotlin.Array<Any> = elements.toList().toTypedArray()
        return com.google.firebase.firestore.FieldValue.arrayRemove(*elementsArray)
    }

    // SKIP @nobridge
    public class func arrayUnion(_ elements: [Any]) -> com.google.firebase.firestore.FieldValue {
        let elementsArray: kotlin.Array<Any> = elements.toList().toTypedArray()
        return com.google.firebase.firestore.FieldValue.arrayUnion(*elementsArray)
    }

    // SKIP @nobridge
    public class func delete() -> com.google.firebase.firestore.FieldValue {
        return com.google.firebase.firestore.FieldValue.delete()
    }

    // SKIP @nobridge
    public class func increment(_ d: Double) -> com.google.firebase.firestore.FieldValue {
        return com.google.firebase.firestore.FieldValue.increment(d)
    }

    // SKIP @nobridge
    public class func increment(_ l: Int64) -> com.google.firebase.firestore.FieldValue {
        return com.google.firebase.firestore.FieldValue.increment(l)
    }

    // SKIP @nobridge
    public class func serverTimestamp() -> com.google.firebase.firestore.FieldValue {
        return com.google.firebase.firestore.FieldValue.serverTimestamp()
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
#endif
