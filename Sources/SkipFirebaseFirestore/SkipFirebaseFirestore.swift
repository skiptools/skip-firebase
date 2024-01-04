// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

import SkipFirebaseCore
#if SKIP
import kotlinx.coroutines.tasks.await

public final class Firestore {
    fileprivate let store: com.google.firebase.firestore.FirebaseFirestore

    private init(store: com.google.firebase.firestore.FirebaseFirestore) {
        self.store = store
    }

    public static func firestore(app: FirebaseApp, database: String) -> Firestore {
        return Firestore(store: com.google.firebase.firestore.FirebaseFirestore.getInstance(app.app, database))
    }

    public func collection(_ collectionPath: String) -> CollectionReference {
        CollectionReference(ref: store.collection(collectionPath))
    }
}

public final class CollectionReference {
    fileprivate let ref: com.google.firebase.firestore.CollectionReference

    fileprivate init(ref: com.google.firebase.firestore.CollectionReference) {
        self.ref = ref
    }

    public func getDocuments() async throws -> QuerySnapshot {
        // SKIP NOWARN
        QuerySnapshot(query: try await ref.get().await())
    }

    public func document(_ path: String) -> DocumentReference {
        DocumentReference(ref: ref.document(path))
    }
}

public final class Query {
    fileprivate let query: com.google.firebase.firestore.Query

    fileprivate init(query: com.google.firebase.firestore.Query) {
        self.query = query
    }
}

public final class QuerySnapshot {
    fileprivate let query: com.google.firebase.firestore.QuerySnapshot

    fileprivate init(query: com.google.firebase.firestore.QuerySnapshot) {
        self.query = query
    }

    public var documents: [DocumentSnapshot] {
        Array(query.documents.map({ DocumentSnapshot(doc: $0) }))
    }
}

public final class DocumentSnapshot {
    fileprivate let doc: com.google.firebase.firestore.DocumentSnapshot

    fileprivate init(doc: com.google.firebase.firestore.DocumentSnapshot) {
        self.doc = doc
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
    fileprivate let ref: com.google.firebase.firestore.DocumentReference

    fileprivate init(ref: com.google.firebase.firestore.DocumentReference) {
        self.ref = ref
    }

    public func getDocument() async throws -> DocumentSnapshot {
        // SKIP NOWARN
        DocumentSnapshot(doc: try await ref.get().await())
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
