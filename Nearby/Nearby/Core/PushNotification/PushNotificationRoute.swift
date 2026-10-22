//
//  PushNotificationRoute.swift
//  Nearby
//
//  Created by h2e on 10/21/26.
//

import Foundation

nonisolated enum PushNotificationRoute {
    case hostRequestReceive(applicationId: Int)
    case companionRequestAccept(applicationId: Int)
    case companionRequestDecline

    // MARK: - Keys

    private enum Key {
        static let type = "type"
        static let applicationId = "applicationId"
    }

    private enum NotificationType: String {
        case applicationCreated = "COMPANION_APPLICATION_CREATED"
        case applicationAccepted = "COMPANION_APPLICATION_ACCEPTED"
        case applicationRejected = "COMPANION_APPLICATION_REJECTED"
    }

    // MARK: - Initializer

    init?(userInfo: [AnyHashable: Any]) {
        guard let rawType = userInfo[Key.type] as? String,
              let type = NotificationType(rawValue: rawType) else { return nil }
        let applicationId = Self.integer(from: userInfo[Key.applicationId])

        switch type {
        case .applicationCreated:
            guard let applicationId else { return nil }
            self = .hostRequestReceive(applicationId: applicationId)
        case .applicationAccepted:
            guard let applicationId else { return nil }
            self = .companionRequestAccept(applicationId: applicationId)
        case .applicationRejected:
            self = .companionRequestDecline
        }
    }

    // MARK: - Method

    private static func integer(from value: Any?) -> Int? {
        switch value {
        case let int as Int:
            return int
        case let string as String:
            return Int(string)
        default:
            return nil
        }
    }
}
