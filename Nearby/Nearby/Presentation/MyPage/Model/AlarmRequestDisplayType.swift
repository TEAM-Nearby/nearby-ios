//
//  AlarmRequestDisplayType.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

enum AlarmRequestDisplayType {
    case sentAccepted
    case sentRejected
    case receivedPending

    var title: String {
        switch self {
        case .sentAccepted:
            return "동행이 수락되었어요"

        case .sentRejected:
            return "아쉽지만 다른 동행을 찾아봐요"

        case .receivedPending:
            return "동행을 원하는 분이 있어요"
        }
    }

    var buttonTitle: String {
        switch self {
        case .sentAccepted:
            return "일정 확정하기"

        case .sentRejected:
            return "확인하기"

        case .receivedPending:
            return "수락하기"
        }
    }

    var icon: UIImage? {
        switch self {
        case .sentAccepted:
            return .imgCheckPurple

        case .sentRejected:
            return nil

        case .receivedPending:
            return .peopleIcon
        }
    }

    var iconSize: CGSize {
        switch self {
        case .sentAccepted:
            return CGSize(width: 20, height: 20)

        case .sentRejected:
            return .zero

        case .receivedPending:
            return CGSize(width: 24, height: 24)
        }
    }

    var iconTintColor: UIColor? {
        switch self {
        case .sentAccepted:
            return nil

        case .sentRejected:
            return nil

        case .receivedPending:
            return .primary40
        }
    }

    var isHighlighted: Bool {
        switch self {
        case .sentAccepted, .receivedPending:
            return true

        case .sentRejected:
            return false
        }
    }
}

struct AlarmRequestItem {

    // MARK: - Properties

    let id: UUID
    let tab: AlarmTab
    let displayType: AlarmRequestDisplayType
    let nickname: String
    let dateText: String
    let profileImage: UIImage?

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        tab: AlarmTab,
        displayType: AlarmRequestDisplayType,
        nickname: String,
        dateText: String,
        profileImage: UIImage? = nil
    ) {
        self.id = id
        self.tab = tab
        self.displayType = displayType
        self.nickname = nickname
        self.dateText = dateText
        self.profileImage = profileImage
    }
}
