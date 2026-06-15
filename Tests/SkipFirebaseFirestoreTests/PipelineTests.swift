// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import Foundation

#if SKIP
import SkipFirebaseCore
import SkipFirebaseFirestore

/// Compile-time smoke tests for the Skip-side Firestore Pipeline wrapper.
///
/// On iOS the wrapper is a thin `@_exported import FirebaseFirestore`, so the
/// Pipeline surface comes from the native SDK and these tests are not needed.
/// On Android the Skip wrapper bridges to `com.google.firebase.firestore.Pipeline`
/// — this test confirms the wrapper's public API surface stays compilable.
@MainActor final class PipelineTests: XCTestCase {

    /// Validates the Pipeline chain compiles end-to-end against the Skip wrapper.
    /// No assertion is made — compile-time validation is the goal.
    func test_pipeline_apiSurface_compiles() {
        if ({ 0 == 1 }()) {
            let db = Firestore.firestore()
            let source: PipelineSource = db.pipeline()
            let _: Pipeline = source.collection("restaurants")
            let _: Pipeline = source.collectionGroup("reviews")

            let chained: Pipeline = db.pipeline()
                .collection("restaurants")
                .whereCondition(PipelineBooleanExpression.fieldEqualTo("city", value: "Amsterdam"))
                .search(query: DocumentMatches("sushi OR ramen"))
                .limit(20)
                .offset(0)
            let _ = chained
        }
    }

    /// Validates that PipelineBooleanExpression factories compile.
    func test_pipeline_expressions_compile() {
        if ({ 0 == 1 }()) {
            let _: PipelineBooleanExpression = PipelineBooleanExpression.documentMatches("pizza OR pasta")
            let _: PipelineBooleanExpression = PipelineBooleanExpression.fieldEqualTo("category", value: "italian")
            let _: PipelineBooleanExpression = PipelineBooleanExpression.fieldArrayContainsAny("tags", values: ["vegan", "gluten-free"])
            let _: PipelineBooleanExpression = DocumentMatches("pizza OR pasta")
        }
    }

    /// Validates that PipelineSnapshot and PipelineResult types compile.
    func test_pipeline_result_types_compile() {
        if ({ 0 == 1 }()) {
            let makeSnapshot: () async throws -> PipelineSnapshot = {
                try await Firestore.firestore()
                    .pipeline()
                    .collection("items")
                    .execute()
            }
            let _ = makeSnapshot

            let checkResult: (PipelineResult) -> Void = { result in
                let _: String? = result.id
                let _: [String: Any] = result.data()
            }
            let _ = checkResult
        }
    }
}

#endif // SKIP
