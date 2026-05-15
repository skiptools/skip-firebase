// Copyright 2025–2026 Skip
// SPDX-License-Identifier: MPL-2.0
#if !SKIP_BRIDGE
#if canImport(FirebasePerformance)
@_exported import FirebasePerformance
#elseif SKIP
import Foundation
import SkipFirebaseCore

// https://firebase.google.com/docs/reference/swift/firebaseperformance/api/reference/Classes/Performance
// https://firebase.google.com/docs/reference/android/com/google/firebase/perf/FirebasePerformance

public enum HTTPMethod: String {
    case connect = "CONNECT"
    case delete = "DELETE"
    case get = "GET"
    case head = "HEAD"
    case options = "OPTIONS"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
    case trace = "TRACE"
}

public final class Performance {
    public let platformValue: com.google.firebase.perf.FirebasePerformance

    public init(platformValue: com.google.firebase.perf.FirebasePerformance) {
        self.platformValue = platformValue
    }

    public static func sharedInstance() -> Performance {
        Performance(platformValue: com.google.firebase.perf.FirebasePerformance.getInstance())
    }

    public var isDataCollectionEnabled: Bool {
        get { platformValue.isPerformanceCollectionEnabled() }
        set { platformValue.setPerformanceCollectionEnabled(newValue) }
    }

    public func trace(name: String) -> Trace? {
        Trace(platformValue: platformValue.newTrace(name))
    }
}

public final class Trace {
    public let platformValue: com.google.firebase.perf.metrics.Trace

    public init(platformValue: com.google.firebase.perf.metrics.Trace) {
        self.platformValue = platformValue
    }

    public func start() {
        platformValue.start()
    }

    public func stop() {
        platformValue.stop()
    }

    public func incrementMetric(_ name: String, by value: Int64) {
        platformValue.incrementMetric(name, value)
    }

    public func valueForMetric(_ name: String) -> Int64 {
        platformValue.getLongMetric(name)
    }

    public func setAttribute(_ value: String, forName name: String) {
        platformValue.putAttribute(name, value)
    }

    public func valueForAttribute(_ name: String) -> String? {
        platformValue.getAttribute(name)
    }

    public func removeAttribute(_ name: String) {
        platformValue.removeAttribute(name)
    }

    public var attributes: [String: String] {
        var result: [String: String] = [:]
        for (key, value) in platformValue.getAttributes() {
            result[key] = value
        }
        return result
    }
}

public final class HTTPMetric {
    public let platformValue: com.google.firebase.perf.metrics.HttpMetric
    private var _responseCode: Int = 0
    private var _requestPayloadSize: Int = 0
    private var _responsePayloadSize: Int = 0
    private var _responseContentType: String? = nil

    public init(url: URL, httpMethod: HTTPMethod) {
        self.platformValue = com.google.firebase.perf.FirebasePerformance.getInstance().newHttpMetric(url.absoluteString, httpMethod.rawValue)
    }

    public func start() {
        platformValue.start()
    }

    public func stop() {
        platformValue.stop()
    }

    public var responseCode: Int {
        get { _responseCode }
        set {
            _responseCode = newValue
            platformValue.setHttpResponseCode(newValue)
        }
    }

    public var requestPayloadSize: Int {
        get { _requestPayloadSize }
        set {
            _requestPayloadSize = newValue
            platformValue.setRequestPayloadSize(Int64(newValue))
        }
    }

    public var responsePayloadSize: Int {
        get { _responsePayloadSize }
        set {
            _responsePayloadSize = newValue
            platformValue.setResponsePayloadSize(Int64(newValue))
        }
    }

    public var responseContentType: String? {
        get { _responseContentType }
        set {
            _responseContentType = newValue
            platformValue.setResponseContentType(newValue)
        }
    }

    public func setAttribute(_ value: String, forName name: String) {
        platformValue.putAttribute(name, value)
    }

    public func valueForAttribute(_ name: String) -> String? {
        platformValue.getAttribute(name)
    }

    public func removeAttribute(_ name: String) {
        platformValue.removeAttribute(name)
    }

    public var attributes: [String: String] {
        var result: [String: String] = [:]
        for (key, value) in platformValue.getAttributes() {
            result[key] = value
        }
        return result
    }
}
#endif
#endif
