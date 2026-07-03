// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseFirestore)
@_exported import FirebaseFirestore
#elseif SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// MARK: - PipelineBooleanExpression

/// A boolean-valued Firestore Pipeline expression.
///
/// Construct via static factories such as ``documentMatches(_:)``,
/// ``fieldEqualTo(_:value:)``, or ``fieldArrayContainsAny(_:values:)``.
public final class PipelineBooleanExpression: KotlinConverting<com.google.firebase.firestore.pipeline.BooleanExpression> {
    public let expression: com.google.firebase.firestore.pipeline.BooleanExpression

    public init(expression: com.google.firebase.firestore.pipeline.BooleanExpression) {
        self.expression = expression
    }

    // SKIP @nooverride
    public override func kotlin(nocopy: Bool = false) -> com.google.firebase.firestore.pipeline.BooleanExpression {
        expression
    }

    /// Full-text search expression: matches documents whose text-indexed fields
    /// contain the given query.
    public static func documentMatches(_ query: String) -> PipelineBooleanExpression {
        PipelineBooleanExpression(expression: com.google.firebase.firestore.pipeline.Expression.documentMatches(query))
    }

    /// Equality filter on `field`.
    public static func fieldEqualTo(_ field: String, value: Any) -> PipelineBooleanExpression {
        let f = com.google.firebase.firestore.pipeline.Expression.field(field)
        return PipelineBooleanExpression(expression: f.equal(value.kotlin()))
    }

    /// `arrayContainsAny` filter on `field` over a list of allowed values.
    public static func fieldArrayContainsAny(_ field: String, values: [Any]) -> PipelineBooleanExpression {
        let f = com.google.firebase.firestore.pipeline.Expression.field(field)
        let list = values.map { $0.kotlin() }.toList()
        return PipelineBooleanExpression(expression: f.arrayContainsAny(list))
    }
}

// MARK: - DocumentMatches

/// Free-function alias for ``PipelineBooleanExpression/documentMatches(_:)``
/// so call sites read like the native Firestore Pipeline API:
/// `pipeline.search(query: DocumentMatches("waffles"))`.
public func DocumentMatches(_ query: String) -> PipelineBooleanExpression {
    PipelineBooleanExpression.documentMatches(query)
}

// MARK: - PipelineSnapshot

/// The results of a Firestore Pipeline execution.
public final class PipelineSnapshot {
    public let snapshot: com.google.firebase.firestore.Pipeline.Snapshot

    public init(snapshot: com.google.firebase.firestore.Pipeline.Snapshot) {
        self.snapshot = snapshot
    }

    /// All documents returned by the pipeline.
    public var results: [PipelineResult] {
        var arr: [PipelineResult] = []
        for r in snapshot.results {
            arr.append(PipelineResult(result: r))
        }
        return arr
    }
}

// MARK: - PipelineResult

/// A single result document from a Firestore Pipeline execution.
public final class PipelineResult {
    public let result: com.google.firebase.firestore.PipelineResult

    public init(result: com.google.firebase.firestore.PipelineResult) {
        self.result = result
    }

    /// The document ID, if available.
    public var id: String? {
        result.getId()
    }

    /// All fields of this result as a Swift dictionary.
    public func data() -> [String: Any] {
        let map = result.getData()
        var dict: [String: Any] = [:]
        if map != nil {
            for (key, val) in map! {
                if let k = key as? String, let v = val {
                    dict[k] = v
                }
            }
        }
        return dict
    }
}

// MARK: - Pipeline

/// A configured Firestore Pipeline. Build one via ``Firestore/pipeline()``
/// followed by ``collection(_:)`` or ``collectionGroup(_:)``, then chain
/// stages and ``execute()``.
public final class Pipeline {
    public let platformPipeline: com.google.firebase.firestore.Pipeline

    public init(platformPipeline: com.google.firebase.firestore.Pipeline) {
        self.platformPipeline = platformPipeline
    }

    /// Filters documents from this pipeline stage using the given boolean expression.
    ///
    /// Equivalent to the native `.where(...)` stage; renamed to avoid clashing
    /// with the Swift `where` keyword in Skip-generated bridge code.
    public func whereCondition(_ condition: PipelineBooleanExpression) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.where(condition.expression))
    }

    /// Performs a full-text search stage using the given boolean expression.
    ///
    /// Typically combined with ``DocumentMatches(_:)``:
    /// `pipeline.search(query: DocumentMatches("..."))`.
    ///
    /// No `// SKIP REPLACE:` override here on purpose: the body below already
    /// transpiles to equivalent Kotlin via direct interop, and a `SKIP REPLACE`
    /// override on this method causes SkipBridge to silently omit `search`
    /// from the generated Swift bridge peer (`Pipeline_Bridge.swift`) even
    /// though the Kotlin transpile output is correct — `limit`/`offset`/
    /// `whereCondition`, which have no override, bridge fine.
    public func search(query: PipelineBooleanExpression) -> Pipeline {
        Pipeline(platformPipeline: platformPipeline.search(
            com.google.firebase.firestore.pipeline.SearchStage.withQuery(query.expression)
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
    ///
    /// Any `FirebaseFirestoreException` thrown by the underlying SDK is
    /// propagated as-is; callers should map it to a domain error as they
    /// would for any other Firestore call.
    public func execute() async throws -> PipelineSnapshot {
        let snapshot = try platformPipeline.execute().await()
        return PipelineSnapshot(snapshot: snapshot)
    }
}

// MARK: - PipelineSource

/// Entry point for building a Firestore Pipeline. Obtain via ``Firestore/pipeline()``.
public final class PipelineSource {
    public let platformSource: com.google.firebase.firestore.PipelineSource

    public init(platformSource: com.google.firebase.firestore.PipelineSource) {
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
    /// Returns a ``PipelineSource`` for building a Firestore Pipeline.
    public func pipeline() -> PipelineSource {
        PipelineSource(platformSource: store.pipeline())
    }
}

#endif // SKIP
#endif // !SKIP_BRIDGE
