// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org

#if SKIP
import OSLog
import SkipFirebaseCore
import SwiftUI
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import androidx.core.util.Consumer
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.tasks.await

// https://firebase.google.com/docs/reference/swift/firebasemessaging/api/reference/Classes/Messaging
// https://firebase.google.com/docs/reference/android/com/google/firebase/messaging/FirebaseMessaging

public final class Messaging: Consumer<Intent>, KotlinConverting<FirebaseMessaging> {
    private static let sharedLock: Object = Object()
    private static var shared: Messaging?

    public let messaging: FirebaseMessaging

    public init(messaging: FirebaseMessaging) {
        self.messaging = messaging
    }

    public var description: String {
        messaging.toString()
    }

    public override func kotlin(nocopy: Bool = false) -> FirebaseMessaging {
        messaging
    }

    public static func messaging() -> Messaging {
        synchronized(sharedLock) {
            if shared == nil {
                shared = Messaging(messaging: FirebaseMessaging.getInstance())
            }
        }
        return shared!
    }

    public var delegate: (any MessagingDelegate)? {
        didSet {
            if let delegate {
                Task { @MainActor in
                    do {
                        delegate.messaging(self, didReceiveRegistrationToken: await token())
                    } catch {
                        android.util.Log.e("SkipFirebaseMessaging", "didReceiveRegistrationToken error", error as? Throwable)
                    }
                }
            }
        }
    }

    /// Call this function after activity is created and initialized.
    public func onActivityCreated(activity: AppCompatActivity) {
        activity.addOnNewIntentListener(self)
        onIntent(activity.intent)
    }

    /// Called automatically from `onActivityCreated` and its `onNewActivity` callback.
    public func onIntent(intent: Intent?) {
        guard let extras = intent?.extras, let identifier = extras.getString("google.message_id") else {
            return
        }
        let notificationCenter = UNUserNotificationCenter.current()
        guard let delegate = notificationCenter.delegate else {
            return
        }

        var userInfo: [AnyHashable: Any] = [:]
        for key in extras.keySet() {
            userInfo[key] = extras.get(key)
        }
        let content = UNNotificationContent(userInfo: userInfo)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: UNPushNotificationTrigger(repeats: false))
        let sentTime = extras.getLong("google.sent_time")
        let date = sentTime == Int64(0) ? Date.now : Date(timeIntervalSince1970: Double(sentTime) / 1000.0)
        let notification = UNNotification(request: request, date: date)
        let response = UNNotificationResponse(notification: notification)
        Task { @MainActor in
            await delegate.userNotificationCenter(notificationCenter, didReceive: response)
        }
    }

    public static func serviceExtension() -> MessagingExtensionHelper {
        return MessagingExtensionHelper()
    }

    public private(set) var apnsToken: Data?

    public func setAPNSToken(_ apnsToken: Data, type: MessagingAPNSTokenType) {
        self.apnsToken = apnsToken
    }

    public var isAutoInitEnabled: Bool {
        get { messaging.isAutoInitEnabled }
        set { messaging.isAutoInitEnabled = newValue }
    }

    public internal(set) var fcmToken: String?

    public func token() async throws -> String {
        messaging.token.await()
    }

    public func deleteToken() async throws {
        messaging.deleteToken().await()
    }

    @available(*, unavailable)
    public func retrieveFCMToken(forSenderID senderID: String) async throws -> String {
        return ""
    }

    @available(*, unavailable)
    public func deleteFCMToken(forSenderID senderID: String) async throws {
    }

    public func subscribe(toTopic topic: String) async throws {
        messaging.subscribeToTopic(topic).await()
    }

    public func unsubscribe(fromTopic topic: String) async throws {
        messaging.unsubscribeFromTopic(topic).await()
    }

    public func appDidReceiveMessage(_ message: [AnyHashable : Any]) -> MessagingMessageInfo {
        return MessagingMessageInfo(status: .unknown)
    }

    public func deleteData() async throws {
        await deleteToken()
    }

    // Called on Activity.onNewIntent
    public override func accept(intent: Intent) {
        onIntent(intent: intent)
    }
}

public class MessagingService : FirebaseMessagingService {
    public init() {
        super.init()
    }

    public override func onDeletedMessages() {
        super.onDeletedMessages()
    }

    public override func onDestroy() {
        super.onDestroy()
    }

    public override func onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        guard let activity = UIApplication.shared.androidActivity, let notification = message.notification else {
            return
        }
        let notificationCenter = UNUserNotificationCenter.current()
        guard let delegate = notificationCenter.delegate else {
            return
        }

        // We recognize notification intents by the google.message_id key
        let messageID = message.messageId ?? "0"
        var userInfo: [AnyHashable: Any] = ["google.message_id": messageID]
        for (key, value) in message.data {
            userInfo[key] = value
        }
        let attachments: [UNNotificationAttachment]
        if let imageUri = notification.imageUrl, let url = URL(string: imageUri.toString()) {
            attachments = [UNNotificationAttachment(identifier: message.messageId ?? "", url: url, type: "public.image")]
        } else {
            attachments = []
        }
        let content = UNNotificationContent(title: notification.title ?? "", body: notification.body ?? "", userInfo: userInfo, attachments: attachments)
        let request = UNNotificationRequest(identifier: messageID, content: content, trigger: UNPushNotificationTrigger(repeats: false))
        let date = Date(timeIntervalSince1970: Double(message.sentTime) / 1000.0)
        let notification = UNNotification(request: request, date: date)

        Task { @MainActor in
            do {
                try await notificationCenter.add(request)
            } catch {
                android.util.Log.e("SkipFirebaseMessaging", "onMessageReceived error", error as? Throwable)
            }
        }
    }

    public override func onMessageSent(msgId: String) {
        super.onMessageSent(msgId)
    }

    public override func onNewToken(token: String) {
        super.onNewToken(token)
        let messaging = Messaging.messaging()
        messaging.fcmToken = token
        messaging.delegate?.messaging(messaging, didReceiveRegistrationToken: token)
    }

    public override func onSendError(msgId: String, exception: Exception) {
        super.onSendError(msgId, exception)
        android.util.Log.e("SkipFirebaseMessaging", "onSendError: \(msgId)", exception)
    }
}

public protocol MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?)
}

extension MessagingDelegate {
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    }
}

public enum MessagingAPNSTokenType : Int {
    case unknown = 0
    case sandbox = 1
    case prod = 2
}

public enum MessagingMessageStatus : Int {
    case unknown = 0
    case new = 1
}

public class MessagingExtensionHelper {
    @available(*, unavailable)
    public func populateNotificationContent(_ content: UNMutableNotificationContent, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
    }

    @available(*, unavailable)
    public func exportDeliveryMetricsToBigQuery(withMessageInfo info: [AnyHashable : Any]) {
    }
}

public class MessagingMessageInfo {
    public let status: MessagingMessageStatus

    init(status: MessagingMessageStatus) {
        self.status = status
    }
}
#endif
