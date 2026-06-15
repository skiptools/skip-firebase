// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseFirestore)
@_exported import FirebaseFirestore
#elseif SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// MARK: - Expression

/// A value that can be used in Firestore Pipeline expressions.
public protocol Expression: AnyObject {
    /// Returns the underlying Kotlin `com.google.firebase.firestore.pipeline.Expression`.
    func kotlinExpression() -> com.google.firebase.firestore.pipeline.Expression
}

// MARK: - BooleanExpression

/// A boolean-valued Pipeline expression.
public protocol BooleanExpression: Expression {
    /// Returns the underlying Kotlin `com.google.firebase.firestore.pipeline.BooleanExpression`.
    func kotlinBooleanExpression() -> com.google.firebase.firestore.pipeline.BooleanExpression
}

extension BooleanExpression {
    public func kotlinExpression() -> com.google.firebase.firestore.pipeline.Expression {
        kotlinBooleanExpression()
    }
}

// MARK: - Field

/// Represents a field reference in a Firestore Pipeline.
public final class Field: Expression {
    let platformField: com.google.firebase.firestore.pipeline.Field

    public init(_ name: String) {
        // SKIP REPLACE: platformField = com.google.firebase.firestore.pipeline.Field.field(name)
        platformField = com.google.firebase.firestore.pipeline.Field.field(name)
    }

    init(platformField: com.google.firebase.firestore.pipeline.Field) {
        self.platformField = platformField
    }

    public func kotlinExpression() -> com.google.firebase.firestore.pipeline.Expression {
        platformField
    }

    /// Creates a `BooleanExpression` that checks if this field equals `value`.
    public func equalTo(_ value: Any) -> BooleanExpression {
        return WrappedBooleanExpression(platformField.equal(value.kotlin()))
    }

    /// Creates a `BooleanExpression` that checks if this field's array contains any of `values`.
    public func arrayContainsAny(_ values: [Any]) -> BooleanExpression {
        let list = values.map { $0.kotlin() }.toList()
        return WrappedBooleanExpression(platformField.arrayContainsAny(list))
    }
}

// MARK: - WrappedBooleanExpression

/// Internal box that wraps a Kotlin `BooleanExpression`.
final class WrappedBooleanExpression: BooleanExpression {
    private let expr: com.google.firebase.firestore.pipeline.BooleanExpression

    init(_ expr: com.google.firebase.firestore.pipeline.BooleanExpression) {
        self.expr = expr
    }

    public func kotlinBooleanExpression() -> com.google.firebase.firestore.pipeline.BooleanExpression {
        expr
    }
}

// MARK: - DocumentMatches

/// A full-text search expression that matches documents against a query string.
///
/// Use this in a `pipeline.search(query:)` stage:
/// ```swift
/// db.pipeline()
///   .collection("restaurants")
///   .search(query: DocumentMatches("waffles OR pancakes"))
/// ```
public final class DocumentMatches: BooleanExpression {
    private let query: String

    public init(_ query: String) {
        self.query = query
    }

    // SKIP REPLACE: override fun kotlinBooleanExpression(): com.google.firebase.firestore.pipeline.BooleanExpression = com.google.firebase.firestore.pipeline.Expression.documentMatches(query)
    public func kotlinBooleanExpression() -> com.google.firebase.firestore.pipeline.BooleanExpression {
        com.google.firebase.firestore.pipeline.Expression.documentMatches(query)
    }
}

// MARK: - PipelineSnapshot

/// The results of a Firestore Pipeline execution.
public final class PipelineSnapshot {
    let snapshot: com.google.firebase.firestore.Pipeline.Snapshot

    init(snapshot: com.google.firebase.firestore.Pipeline.Snapshot) {
        self.snapshot = snapshot
    }

    /// All documents returned by the pipeline.
    public var results: [PipelineResult] {
        snapshot.results.map { PipelineResult(result: $0) }
    }
}

// MARK: - PipelineResult

/// A single result document from a Firestore Pipeline execution.
public final class PipelineResult {
    let result: com.google.firebase.firestore.PipelineResult

    init(result: com.google.firebase.firestore.PipelineResult) {
        self.result = result
    }

    /// The document ID, if available.
    public var id: String? {
        result.getId()
    }

    /// All fields of this result as a Swift dictionary.
    public func data() -> [String: Any] {
        let map = result.getData()
        var dict = [String: Any]()
        for (key, val) in map {
            if let k = key as? String, let v = val {
                dict[k] = v
            }
        }
        return dict
    }
}

// MARK: - Pipeline

/// A Firestore Pipeline that can be configured and executed.
public final class Pipeline {
    let platformPipeline: com.google.firebase.firestore.Pipeline

    init(platformPipeline: com.google.firebase.firestore.Pipeline) {
        self.platformPipeline = platformPipeline
    }

    /// Filters documents from this pipeline stage using the given boolean expression.
    public func `where`(_ condition: BooleanExpression) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.where(condition.kotlinBooleanExpression()))
    }

    /// Performs a full-text search stage using the given `BooleanExpression` (e.g. `DocumentMatches`).
    ///
    /// On Android, this uses `Pipeline.search(SearchStage)` via `SearchStage.Companion.withQuery`.
    // SKIP REPLACE: fun search(query: BooleanExpression): Pipeline = Pipeline(platformPipeline = platformPipeline.search(com.google.firebase.firestore.pipeline.SearchStage.withQuery(query.kotlinBooleanExpression())))
    public func search(query: BooleanExpression) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.search(
            com.google.firebase.firestore.pipeline.SearchStage.withQuery(query.kotlinBooleanExpression())
        ))
    }

    /// Limits the number of results returned by this pipeline.
    public func limit(_ n: Int) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.limit(n))
    }

    /// Skips the first `n` results of this pipeline.
    public func offset(_ n: Int) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.offset(n))
    }

    /// Executes this pipeline and returns its results.
    public func execute() async throws -> PipelineSnapshot {
        do {
            let snapshot = try platformPipeline.execute().await()
            return PipelineSnapshot(snapshot: snapshot)
        } catch is com.google.firebase.firestore.FirebaseFirestoreException {
            throw asNSError(firestoreException: error)
        }
    }
}

// MARK: - PipelineSource

/// Entry point for building a Firestore Pipeline.
///
/// Obtain an instance via `Firestore.pipeline()`.
public final class PipelineSource {
    let platformSource: com.google.firebase.firestore.PipelineSource

    init(platformSource: com.google.firebase.firestore.PipelineSource) {
        self.platformSource = platformSource
    }

    /// Starts a pipeline from a collection at the given path.
    public func collection(_ path: String) -> Pipeline {
        Pipeline(platformPipeline: platformSource.collection(path))
    }

    /// Starts a pipeline from a collection group with the given ID.
    public func collectionGroup(_ id: String) -> Pipeline {
        Pipeline(platformPipeline: platformSource.collectionGroup(id))
    }
}

// MARK: - Firestore extension

extension Firestore {
    /// Returns a `PipelineSource` for building a Firestore Pipeline.
    public func pipeline() -> PipelineSource {
        PipelineSource(platformSource: store.pipeline())
    }
}

#endif // SKIP
#endif // !SKIP_BRIDGE
