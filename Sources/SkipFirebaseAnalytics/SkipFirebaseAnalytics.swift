// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if canImport(FirebaseAnalytics)
@_exported import FirebaseAnalytics
#elseif SKIP
import SkipFirebaseCore
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebaseanalytics/api/reference/Classes/Analytics
// https://firebase.google.com/docs/reference/android/com/google/firebase/analytics/FirebaseAnalytics

public final class Analytics {
    public let analytics: com.google.firebase.analytics.FirebaseAnalytics

    public init(analytics: com.google.firebase.analytics.FirebaseAnalytics) {
        self.analytics = analytics
    }

//    public static func analytics() -> Analytics {
//        Analytics(analytics: com.google.firebase.analytics.FirebaseAnalytics.getInstance())
//    }

    public static func logEvent(_ name: String, parameters: [String: Any] = [:]) {
        let bundle = android.os.Bundle()
        // TODO: add parameters to bundle
        com.google.firebase.analytics.FirebaseAnalytics.getInstance(skip.foundation.ProcessInfo.processInfo.androidContext).logEvent(name, bundle)
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
