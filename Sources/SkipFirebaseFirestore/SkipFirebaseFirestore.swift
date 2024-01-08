// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class Firestore {
    public let store: com.google.firebase.firestore.FirebaseFirestore

    public init(store: com.google.firebase.firestore.FirebaseFirestore) {
        self.store = store
    }

    public var description: String {
        store.toString()
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
}

/// A FieldPath refers to a field in a document. The path may consist of a single field name (referring to a top level field in the document), or a list of field names (referring to a nested field in the document).
public class FieldPath : Equatable {
    public let fieldPath: com.google.firebase.firestore.FieldPath

    public init(fieldPath: com.google.firebase.firestore.FieldPath) {
        self.fieldPath = fieldPath
    }

    public init(_ fieldNames: [String]) {
        let fnames: kotlin.Array<String> = fieldNames.toList().toTypedArray()
        self.fieldPath = com.google.firebase.firestore.FieldPath.of(*fnames)
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.fieldPath == rhs.fieldPath
    }

    public var description: String {
        fieldPath.toString()
    }
}

/// A query that calculates aggregations over an underlying query.
public class AggregateQuery {
    public let query: com.google.firebase.firestore.AggregateQuery

    public init(query: com.google.firebase.firestore.AggregateQuery) {
        self.query = query
    }

    public var description: String {
        query.toString()
    }
}

public class Filter {
    public let filter: com.google.firebase.firestore.Filter

    public init(filter: com.google.firebase.firestore.Filter = com.google.firebase.firestore.Filter()) {
        self.filter = filter
    }
}

public class Query {
    public let query: com.google.firebase.firestore.Query

    public init(query: com.google.firebase.firestore.Query) {
        self.query = query
    }

    public var description: String {
        query.toString()
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
}

public final class CollectionReference : Query {
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

    public func getDocuments() async throws -> QuerySnapshot {
        // SKIP NOWARN
        QuerySnapshot(query: try await ref.get().await())
    }

    public func document(_ path: String) -> DocumentReference {
        DocumentReference(ref: ref.document(path))
    }

    public func document() -> DocumentReference {
        DocumentReference(ref: ref.document())
    }

    public func addDocument(data: [String: Any]) async throws -> DocumentReference {
        // SKIP NOWARN
        try await DocumentReference(ref: try await ref.add(deepKotlin(dict: data)).await())
    }
}

public final class Transaction {
    public let transaction: com.google.firebase.firestore.Transaction

    public init(transaction: com.google.firebase.firestore.Transaction) {
        self.transaction = transaction
    }

    public var description: String {
        transaction.toString()
    }
}

public final class QuerySnapshot {
    public let query: com.google.firebase.firestore.QuerySnapshot

    public init(query: com.google.firebase.firestore.QuerySnapshot) {
        self.query = query
    }

    public var description: String {
        query.toString()
    }

    public var documents: [DocumentSnapshot] {
        Array(query.documents.map({ DocumentSnapshot(doc: $0) }))
    }
}

public final class DocumentSnapshot {
    public let doc: com.google.firebase.firestore.DocumentSnapshot

    public init(doc: com.google.firebase.firestore.DocumentSnapshot) {
        self.doc = doc
    }

    public var description: String {
        doc.toString()
    }

    public var documentID: String {
        doc.getId()
    }

    public func data() -> [String: Any] {
        if let data = doc.getData() {
            return Dictionary(data)
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

public final class DocumentReference {
    public let ref: com.google.firebase.firestore.DocumentReference

    public init(ref: com.google.firebase.firestore.DocumentReference) {
        self.ref = ref
    }

    public var description: String {
        ref.toString()
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

    public func setData(_ keyValues: [Any: Any], merge: Bool = false) async throws {
        if merge == true {
            // SKIP NOWARN
            try await ref.set(deepKotlin(dict: keyValues), com.google.firebase.firestore.SetOptions.merge())
        } else {
            // SKIP NOWARN
            try await ref.set(deepKotlin(dict: keyValues))
        }
    }

    public func updateData(_ keyValues: [String: Any]) async throws {
        // SKIP NOWARN
        try await ref.update(deepKotlin(dict: keyValues))
    }
}

fileprivate func deepKotlin(value: Any) -> Any {
    if let dictionary = value as? Dictionary<Any, Any> {
        return deepKotlin(dict: dictionary)
    } else if let collection = value as? Collection<Any> {
        return deepKotlin(collection: collection)
    } else {
        return value
    }
}

fileprivate func deepKotlin<T>(dict: Dictionary<T, Any>) -> kotlin.collections.Map<T, Any> {
    var map = mutableMapOf<T, Any>()
    for (key, value) in dict {
        map[key] = deepKotlin(value: value)
    }
    return map
}

fileprivate func deepKotlin(collection: Collection<Any>) -> kotlin.collections.List<Any> {
    var list = mutableListOf<Any>()
    for value in collection {
        list.add(deepKotlin(value: value))
    }
    return list
}


fileprivate func deepSwift(value: Any) -> Any {
    if let str = value as? String {
        return str // needed to not be treated as a Collection
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
