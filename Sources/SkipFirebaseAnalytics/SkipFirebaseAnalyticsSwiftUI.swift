// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE
#if SKIP
import SwiftUI

struct LoggedAnalyticsModifier: ViewModifier {
    /// The name of the view to log in the `AnalyticsParameterScreenName` parameter.
    let screenName: String
    
    /// The name of the view to log in the `AnalyticsParameterScreenClass` parameter.
    let screenClass: String
    
    /// Extra parameters to log with the screen view event.
    let extraParameters: [String: Any]
    
    func body(content: Content) -> some View {
        // Take the content and add an onAppear action to know when the view has appeared on screen.
        content.onAppear {
            // Log the event appearing, adding the appropriate keys and values needed for screen
            // view events.
            var parameters = extraParameters
            parameters[AnalyticsParameterScreenName] = screenName
            parameters[AnalyticsParameterScreenClass] = screenClass
            Analytics.logEvent(AnalyticsEventScreenView, parameters: parameters)
        }
    }
}

public extension View {
    /// Logs `screen_view` events in Google Analytics for Firebase when this view appears on screen.
    /// - Parameters:
    ///   - name: Current screen name logged with the `screen_view` event.
    ///   - class: Current screen class or struct logged with the `screen_view` event.
    ///   - extraParameters: Any additional parameters to be logged. These extra parameters must
    ///       follow the same rules as described in the `Analytics.logEvent(_:parameters:)` docs.
    /// - Returns: A view with a custom `ViewModifier` used to log `screen_view` events when this
    ///    view appears on screen.
    func analyticsScreen(name: String,
                         class: String = "View",
                         extraParameters: [String: Any] = [:]) -> some View {
        // `self` is the view, we're just adding an `LoggedAnalyticsModifier` modifier on it.
        modifier(LoggedAnalyticsModifier(screenName: name,
                                         screenClass: `class`,
                                         extraParameters: extraParameters))
    }
}

#endif
#endif
