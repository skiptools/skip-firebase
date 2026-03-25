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
    func skipTests() throws {
        throw XCTSkip("test intentionally skipped because it exists just for compiler validation")
    }

    func testLogEvent() throws {
        try skipTests()

        let params: [String: Any] = [
            AnalyticsParameterItemName: "test_item",
            AnalyticsParameterPrice: 9.99,
            AnalyticsParameterQuantity: 1,
            AnalyticsParameterCurrency: "USD"
        ]
        Analytics.logEvent("ABC", parameters: params)
    }

    func testSetUserProperty() throws {
        try skipTests()

        Analytics.setUserProperty("X", forName: "Y")
        Analytics.setUserProperty(nil, forName: "Y")
    }

    func testSetUserID() throws {
        try skipTests()

        Analytics.setUserID(nil)
        Analytics.setUserID("ABC")
    }

    func testSetAnalyticsCollectionEnabled() throws {
        try skipTests()

        Analytics.setAnalyticsCollectionEnabled(false)
    }

    func testSetDefaultEventParameters() throws {
        try skipTests()

        Analytics.setDefaultEventParameters(nil)
        Analytics.setDefaultEventParameters(["x": false])
    }

    func testResetAnalyticsData() throws {
        try skipTests()

        Analytics.resetAnalyticsData()
    }

    func testAppInstanceID() throws {
        try skipTests()

        let _: String? = Analytics.appInstanceID()
    }

    func testSessionID() async throws {
        try skipTests()

        let _: Int64? = try await Analytics.sessionID()
    }

    func testSetSessionTimeoutInterval() throws {
        try skipTests()

        Analytics.setSessionTimeoutInterval(TimeInterval(100.0))
    }

    func testConsentTypes() throws {
        try skipTests()

        // Verify ConsentType static members exist and are the right type
        let _: ConsentType = .adPersonalization
        let _: ConsentType = .adStorage
        let _: ConsentType = .adUserData
        let _: ConsentType = .analyticsStorage
    }

    func testConsentStatus() throws {
        try skipTests()

        // Verify ConsentStatus static members exist and are the right type
        let _: ConsentStatus = .granted
        let _: ConsentStatus = .denied
    }

    func testSetConsent() throws {
        try skipTests()

        Analytics.setConsent([
            .analyticsStorage: .granted,
            .adPersonalization: .denied
        ])
    }

    func testEventNameConstants() throws {
        try skipTests()

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

    func testParameterNameConstants() throws {
        try skipTests()

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

    func testUserPropertyConstants() throws {
        try skipTests()

        let _: String = AnalyticsUserPropertyAllowAdPersonalizationSignals
        let _: String = AnalyticsUserPropertySignUpMethod
    }
}
