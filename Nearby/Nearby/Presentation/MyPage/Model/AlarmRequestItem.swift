//
//  AlarmRequestItem.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Foundation

struct AlarmRequestItem: Identifiable {

    // MARK: - Properties

    let id: Int
    let notificationId: Int
    let applicationId: Int
    let tab: AlarmTab
    let displayType: AlarmRequestDisplayType

    let hostUserId: Int
    let nickname: String
    let profileImageURL: URL?

    let placeName: String
    let meetingAt: String
    let dateText: String

    let matchId: Int?
    let actionType: CompanionRequestActionType
    var isRead: Bool

    // MARK: - Initializer

    init(dto: CompanionRequestDTO, tab: AlarmTab) {
        id = dto.notificationId
        notificationId = dto.notificationId
        applicationId = dto.applicationId
        self.tab = tab

        displayType = AlarmRequestDisplayType(tab: tab, status: dto.applicationStatus)

        hostUserId = dto.host.userId
        nickname = dto.host.nickname
        profileImageURL = dto.host.profileImageUrl.flatMap(URL.init(string:))

        placeName = dto.placeName
        meetingAt = dto.meetingAt
        dateText = dto.meetingAt.toDate()?.alarmMeetingDisplayText ?? dto.meetingAt

        matchId = dto.matchId
        actionType = dto.actionType
        isRead = dto.isRead
    }
}

// MARK: - AlarmRequestDisplayType

private extension AlarmRequestDisplayType {

    init(tab: AlarmTab, status: CompanionRequestStatus) {
        switch (tab, status) {
        case (.sent, .pending):
            self = .sentPending

        case (.sent, .accepted):
            self = .sentAccepted

        case (.sent, .rejected):
            self = .sentRejected

        case (.sent, .canceled):
            self = .sentCanceled

        case (.received, .pending):
            self = .receivedPending

        case (.received, .accepted):
            self = .receivedAccepted

        case (.received, .rejected):
            self = .receivedRejected

        case (.received, .canceled):
            self = .receivedCanceled
        }
    }
}
