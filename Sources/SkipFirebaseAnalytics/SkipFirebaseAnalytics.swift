// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebaseAnalytics)
@_exported import FirebaseAnalytics
#elseif SKIP
import Foundation
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Classes/Analytics
// https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics

public final class Analytics {
    public let analytics: com.google.firebase.analytics.FirebaseAnalytics

    public init(analytics: com.google.firebase.analytics.FirebaseAnalytics) {
        self.analytics = analytics
    }

    private static var instance: com.google.firebase.analytics.FirebaseAnalytics {
        com.google.firebase.analytics.FirebaseAnalytics.getInstance(skip.foundation.ProcessInfo.processInfo.androidContext)
    }

    private static func toBundle(_ parameters: [String: Any]?) -> android.os.Bundle? {
        guard let parameters = parameters else { return nil }
        let bundle = android.os.Bundle()
        for (key, value) in parameters {
            if let s = value as? String {
                bundle.putString(key, s)
            } else if let b = value as? Bool {
                bundle.putBoolean(key, b)
            } else if let i = value as? Int {
                bundle.putLong(key, Int64(i))
            } else if let l = value as? Int64 {
                bundle.putLong(key, l)
            } else if let d = value as? Double {
                bundle.putDouble(key, d)
            } else if let f = value as? Float {
                bundle.putFloat(key, f)
            } else {
                bundle.putString(key, "\(value)")
            }
        }
        return bundle
    }

    public static func logEvent(_ name: String, parameters: [String: Any]? = nil) {
        instance.logEvent(name, toBundle(parameters ?? [:]))
    }

    public static func setUserProperty(_ value: String?, forName name: String) {
        instance.setUserProperty(name, value)
    }

    public static func setUserID(_ userID: String?) {
        instance.setUserId(userID)
    }

    public static func setAnalyticsCollectionEnabled(_ enabled: Bool) {
        instance.setAnalyticsCollectionEnabled(enabled)
    }

    public static func setDefaultEventParameters(_ parameters: [String: Any]?) {
        instance.setDefaultEventParameters(toBundle(parameters))
    }

    public static func resetAnalyticsData() {
        instance.resetAnalyticsData()
    }

    public static func appInstanceID() -> String? {
        // Android's getAppInstanceId() returns Task<String>; block to match synchronous iOS API
        return com.google.android.gms.tasks.Tasks.await(instance.getAppInstanceId())
    }

    public static func sessionID() async throws -> Int64? {
        let id = instance.getSessionId().await()
        return id as? Int64
    }

    public static func setSessionTimeoutInterval(_ seconds: TimeInterval) {
        instance.setSessionTimeoutDuration(Int64(seconds * 1000.0))
    }

    public static func setConsent(_ consentSettings: [ConsentType: ConsentStatus]) {
        let map = java.util.HashMap<com.google.firebase.analytics.FirebaseAnalytics.ConsentType, com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus>()
        for (type, status) in consentSettings {
            map.put(type.platformValue, status.platformValue)
        }
        instance.setConsent(map)
    }
}

public struct ConsentType: Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let adPersonalization = ConsentType(rawValue: "ad_personalization")
    public static let adStorage = ConsentType(rawValue: "ad_storage")
    public static let adUserData = ConsentType(rawValue: "ad_user_data")
    public static let analyticsStorage = ConsentType(rawValue: "analytics_storage")

    public var platformValue: com.google.firebase.analytics.FirebaseAnalytics.ConsentType {
        switch rawValue {
        case "ad_personalization": return com.google.firebase.analytics.FirebaseAnalytics.ConsentType.AD_PERSONALIZATION
        case "ad_storage": return com.google.firebase.analytics.FirebaseAnalytics.ConsentType.AD_STORAGE
        case "ad_user_data": return com.google.firebase.analytics.FirebaseAnalytics.ConsentType.AD_USER_DATA
        case "analytics_storage": return com.google.firebase.analytics.FirebaseAnalytics.ConsentType.ANALYTICS_STORAGE
        default: return com.google.firebase.analytics.FirebaseAnalytics.ConsentType.ANALYTICS_STORAGE
        }
    }
}

public struct ConsentStatus: Hashable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public static let granted = ConsentStatus(rawValue: "granted")
    public static let denied = ConsentStatus(rawValue: "denied")

    public var platformValue: com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus {
        switch rawValue {
        case "granted": return com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus.GRANTED
        case "denied": return com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus.DENIED
        default: return com.google.firebase.analytics.FirebaseAnalytics.ConsentStatus.DENIED
        }
    }
}

// FIREventNames.h
public let AnalyticsEventAdImpression = "ad_impression"
public let AnalyticsEventAddPaymentInfo = "add_payment_info"
public let AnalyticsEventAddShippingInfo = "add_shipping_info"
public let AnalyticsEventAddToCart = "add_to_cart"
public let AnalyticsEventAddToWishlist = "add_to_wishlist"
public let AnalyticsEventAppOpen = "app_open"
public let AnalyticsEventBeginCheckout = "begin_checkout"
public let AnalyticsEventCampaignDetails = "campaign_details"
public let AnalyticsEventEarnVirtualCurrency = "earn_virtual_currency"
public let AnalyticsEventGenerateLead = "generate_lead"
public let AnalyticsEventJoinGroup = "join_group"
public let AnalyticsEventLevelEnd = "level_end"
public let AnalyticsEventLevelStart = "level_start"
public let AnalyticsEventLevelUp = "level_up"
public let AnalyticsEventLogin = "login"
public let AnalyticsEventPostScore = "post_score"
public let AnalyticsEventPurchase = "purchase"
public let AnalyticsEventRefund = "refund"
public let AnalyticsEventRemoveFromCart = "remove_from_cart"
public let AnalyticsEventScreenView = "screen_view"
public let AnalyticsEventSearch = "search"
public let AnalyticsEventSelectContent = "select_content"
public let AnalyticsEventSelectItem = "select_item"
public let AnalyticsEventSelectPromotion = "select_promotion"
public let AnalyticsEventShare = "share"
public let AnalyticsEventSignUp = "sign_up"
public let AnalyticsEventSpendVirtualCurrency = "spend_virtual_currency"
public let AnalyticsEventTutorialBegin = "tutorial_begin"
public let AnalyticsEventTutorialComplete = "tutorial_complete"
public let AnalyticsEventUnlockAchievement = "unlock_achievement"
public let AnalyticsEventViewCart = "view_cart"
public let AnalyticsEventViewItem = "view_item"
public let AnalyticsEventViewItemList = "view_item_list"
public let AnalyticsEventViewPromotion = "view_promotion"
public let AnalyticsEventViewSearchResults = "view_search_results"

// FIRParameterNames.h
public let AnalyticsParameterAchievementID = "achievement_id"
public let AnalyticsParameterAdFormat = "ad_format"
public let AnalyticsParameterAdNetworkClickID = "aclid"
public let AnalyticsParameterAdPlatform = "ad_platform"
public let AnalyticsParameterAdSource = "ad_source"
public let AnalyticsParameterAdUnitName = "ad_unit_name"
public let AnalyticsParameterAffiliation = "affiliation"
public let AnalyticsParameterCP1 = "cp1"
public let AnalyticsParameterCampaign = "campaign"
public let AnalyticsParameterCampaignID = "campaign_id"
public let AnalyticsParameterCharacter = "character"
public let AnalyticsParameterContent = "content"
public let AnalyticsParameterContentType = "content_type"
public let AnalyticsParameterCoupon = "coupon"
public let AnalyticsParameterCreativeFormat = "creative_format"
public let AnalyticsParameterCreativeName = "creative_name"
public let AnalyticsParameterCreativeSlot = "creative_slot"
public let AnalyticsParameterCurrency = "currency"
public let AnalyticsParameterDestination = "destination"
public let AnalyticsParameterDiscount = "discount"
public let AnalyticsParameterEndDate = "end_date"
public let AnalyticsParameterExtendSession = "extend_session"
public let AnalyticsParameterFlightNumber = "flight_number"
public let AnalyticsParameterGroupID = "group_id"
public let AnalyticsParameterIndex = "index"
public let AnalyticsParameterItemBrand = "item_brand"
public let AnalyticsParameterItemCategory = "item_category"
public let AnalyticsParameterItemCategory2 = "item_category2"
public let AnalyticsParameterItemCategory3 = "item_category3"
public let AnalyticsParameterItemCategory4 = "item_category4"
public let AnalyticsParameterItemCategory5 = "item_category5"
public let AnalyticsParameterItemID = "item_id"
public let AnalyticsParameterItemListID = "item_list_id"
public let AnalyticsParameterItemListName = "item_list_name"
public let AnalyticsParameterItemName = "item_name"
public let AnalyticsParameterItemVariant = "item_variant"
public let AnalyticsParameterItems = "items"
public let AnalyticsParameterLevel = "level"
public let AnalyticsParameterLevelName = "level_name"
public let AnalyticsParameterLocation = "location"
public let AnalyticsParameterLocationID = "location_id"
public let AnalyticsParameterMarketingTactic = "marketing_tactic"
public let AnalyticsParameterMedium = "medium"
public let AnalyticsParameterMethod = "method"
public let AnalyticsParameterNumberOfNights = "number_of_nights"
public let AnalyticsParameterNumberOfPassengers = "number_of_passengers"
public let AnalyticsParameterNumberOfRooms = "number_of_rooms"
public let AnalyticsParameterOrigin = "origin"
public let AnalyticsParameterPaymentType = "payment_type"
public let AnalyticsParameterPrice = "price"
public let AnalyticsParameterPromotionID = "promotion_id"
public let AnalyticsParameterPromotionName = "promotion_name"
public let AnalyticsParameterQuantity = "quantity"
public let AnalyticsParameterScore = "score"
public let AnalyticsParameterScreenClass = "screen_class"
public let AnalyticsParameterScreenName = "screen_name"
public let AnalyticsParameterSearchTerm = "search_term"
public let AnalyticsParameterShipping = "shipping"
public let AnalyticsParameterShippingTier = "shipping_tier"
public let AnalyticsParameterSource = "source"
public let AnalyticsParameterSourcePlatform = "source_platform"
public let AnalyticsParameterStartDate = "start_date"
public let AnalyticsParameterSuccess = "success"
public let AnalyticsParameterTax = "tax"
public let AnalyticsParameterTerm = "term"
public let AnalyticsParameterTransactionID = "transaction_id"
public let AnalyticsParameterTravelClass = "travel_class"
public let AnalyticsParameterValue = "value"
public let AnalyticsParameterVirtualCurrencyName = "virtual_currency_name"

// FIRUserPropertyNames.h
public let AnalyticsUserPropertyAllowAdPersonalizationSignals = "allow_personalized_ads"
public let AnalyticsUserPropertySignUpMethod = "sign_up_method"
#endif
#endif
