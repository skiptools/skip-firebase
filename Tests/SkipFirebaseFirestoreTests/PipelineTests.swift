// Copyright 2026 Skip
// SPDX-License-Identifier: MPL-2.0
import XCTest
import Foundation

#if !SKIP
import FirebaseCore
import FirebaseFirestore
#else
import SkipFirebaseCore
import SkipFirebaseFirestore
#endif

/// Compile-time smoke tests for the Firestore Pipeline API wrapper.
///
/// These tests validate that the API surface compiles correctly on both
/// iOS (FirebaseFirestore) and Android (SkipFirebaseFirestore). Runtime
/// assertions require a connected Firestore emulator and are guarded accordingly.
@MainActor final class PipelineTests: XCTestCase {

    /// Validates that the full Pipeline chain compiles end-to-end.
    /// No assertion is made — compile-time validation is the goal.
    func test_pipeline_apiSurface_compiles() {
        // This function is never called; it exists to verify the API
        // compiles on both platforms.
        if ({ 0 == 1 }()) {
            let db = Firestore.firestore()

            // PipelineSource from Firestore
            let source: PipelineSource = db.pipeline()

            // Collection and collectionGroup entry points
            let _: Pipeline = source.collection("restaurants")
            let _: Pipeline = source.collectionGroup("reviews")

            // where + search + limit + offset chaining
            let query: Pipeline = db.pipeline()
                .collection("restaurants")
                .where(Field("city").equalTo("Amsterdam"))
                .search(query: DocumentMatches("sushi OR ramen"))
                .limit(20)
                .offset(0)

            let _ = query
        }
    }

    /// Validates that Field and BooleanExpression subtypes compile correctly.
    func test_pipeline_field_expressions_compile() {
        if ({ 0 == 1 }()) {
            let _: BooleanExpression = Field("category").equalTo("italian")
            let _: BooleanExpression = Field("tags").arrayContainsAny(["vegan", "gluten-free"])
            let _: BooleanExpression = DocumentMatches("pizza OR pasta")
        }
    }

    /// Validates that PipelineSnapshot and PipelineResult types compile correctly.
    func test_pipeline_result_types_compile() {
        if ({ 0 == 1 }()) {
            // Just type-check: these are only obtainable from execute() in real code
            let makeSnapshot: () async throws -> PipelineSnapshot = {
                try await Firestore.firestore()
                    .pipeline()
                    .collection("items")
                    .execute()
            }
            let _ = makeSnapshot

            // Validate PipelineResult API surface
            let checkResult: (PipelineResult) -> Void = { result in
                let _: String? = result.id
                let _: [String: Any] = result.data()
            }
            let _ = checkResult
        }
    }
}
