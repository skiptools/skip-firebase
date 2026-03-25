// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
import XCTest
import OSLog
import Foundation
#if !SKIP
import FirebaseCore
import FirebaseAnalytics
#else
import SkipFirebaseCore
import SkipFirebaseAnalytics
#endif

let logger: Logger = Logger(subsystem: "SkipFirebaseAnalyticsTests", category: "Tests")

@MainActor final class SkipFirebaseAnalyticsTests: XCTestCase {
    func testSkipFirebaseAnalyticsTests() async throws {
        Analytics.logEvent("x", parameters: ["a": [1, 2, false]])
    }

    func testLogEventWithNoParameters() {
        // Verify logEvent compiles with no parameters
        let _: (String, [String: Any]?) -> Void = Analytics.logEvent
    }

    func testLogEventWithStringParameters() {
        let _: (String, [String: Any]?) -> Void = Analytics.logEvent
        // Verify parameter types compile
        let params: [String: Any] = [
            AnalyticsParameterItemName: "test_item",
            AnalyticsParameterPrice: 9.99,
            AnalyticsParameterQuantity: 1,
            AnalyticsParameterCurrency: "USD"
        ]
        _ = params
    }

    func testSetUserProperty() {
        let _: (String?, String) -> Void = Analytics.setUserProperty(_:forName:)
    }

    func testSetUserID() {
        let _: (String?) -> Void = Analytics.setUserID
    }

    func testSetAnalyticsCollectionEnabled() {
        let _: (Bool) -> Void = Analytics.setAnalyticsCollectionEnabled
    }

    func testSetDefaultEventParameters() {
        let _: ([String: Any]?) -> Void = Analytics.setDefaultEventParameters
    }

    func testResetAnalyticsData() {
        let _: () -> Void = Analytics.resetAnalyticsData
    }

    func testAppInstanceID() {
        let _: () -> String? = Analytics.appInstanceID
    }

    func testSessionID() {
        // sessionID is async throws -> Int64?
        let _: () async throws -> Int64? = Analytics.sessionID
    }

    func testSetSessionTimeoutInterval() {
        let _: (TimeInterval) -> Void = Analytics.setSessionTimeoutInterval
    }

    func testConsentTypes() {
        // Verify ConsentType static members exist and are the right type
        let _: ConsentType = .adPersonalization
        let _: ConsentType = .adStorage
        let _: ConsentType = .adUserData
        let _: ConsentType = .analyticsStorage
    }

    func testConsentStatus() {
        // Verify ConsentStatus static members exist and are the right type
        let _: ConsentStatus = .granted
        let _: ConsentStatus = .denied
    }

    func testSetConsent() {
        let _: ([ConsentType: ConsentStatus]) -> Void = Analytics.setConsent
    }

    func testEventNameConstants() {
        // Verify event name constants exist and are strings
        let events: [String] = [
            AnalyticsEventAdImpression,
            AnalyticsEventAddPaymentInfo,
            AnalyticsEventAddShippingInfo,
            AnalyticsEventAddToCart,
            AnalyticsEventAddToWishlist,
            AnalyticsEventAppOpen,
            AnalyticsEventBeginCheckout,
            AnalyticsEventCampaignDetails,
            AnalyticsEventEarnVirtualCurrency,
            AnalyticsEventGenerateLead,
            AnalyticsEventJoinGroup,
            AnalyticsEventLevelEnd,
            AnalyticsEventLevelStart,
            AnalyticsEventLevelUp,
            AnalyticsEventLogin,
            AnalyticsEventPostScore,
            AnalyticsEventPurchase,
            AnalyticsEventRefund,
            AnalyticsEventRemoveFromCart,
            AnalyticsEventScreenView,
            AnalyticsEventSearch,
            AnalyticsEventSelectContent,
            AnalyticsEventSelectItem,
            AnalyticsEventSelectPromotion,
            AnalyticsEventShare,
            AnalyticsEventSignUp,
            AnalyticsEventSpendVirtualCurrency,
            AnalyticsEventTutorialBegin,
            AnalyticsEventTutorialComplete,
            AnalyticsEventUnlockAchievement,
            AnalyticsEventViewCart,
            AnalyticsEventViewItem,
            AnalyticsEventViewItemList,
            AnalyticsEventViewPromotion,
            AnalyticsEventViewSearchResults,
        ]
        XCTAssertFalse(events.isEmpty)
    }

    func testParameterNameConstants() {
        // Verify a representative set of parameter constants exist and are strings
        let params: [String] = [
            AnalyticsParameterItemName,
            AnalyticsParameterItemID,
            AnalyticsParameterPrice,
            AnalyticsParameterQuantity,
            AnalyticsParameterCurrency,
            AnalyticsParameterValue,
            AnalyticsParameterScreenName,
            AnalyticsParameterScreenClass,
            AnalyticsParameterSearchTerm,
            AnalyticsParameterMethod,
            AnalyticsParameterScore,
            AnalyticsParameterLevel,
            AnalyticsParameterContent,
            AnalyticsParameterContentType,
            AnalyticsParameterCoupon,
            AnalyticsParameterTransactionID,
            AnalyticsParameterShipping,
            AnalyticsParameterTax,
        ]
        XCTAssertFalse(params.isEmpty)
    }

    func testUserPropertyConstants() {
        let _: String = AnalyticsUserPropertyAllowAdPersonalizationSignals
        let _: String = AnalyticsUserPropertySignUpMethod
    }
}
