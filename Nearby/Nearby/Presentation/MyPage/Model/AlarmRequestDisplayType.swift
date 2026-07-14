//
//  AlarmRequestDisplayType.swift
//  Nearby
//
//  Created by 신서연 on 7/10/26.
//

import UIKit

enum AlarmRequestDisplayType {
    case sentPending
    case sentAccepted
    case sentRejected
    case sentCanceled

    case receivedPending
    case receivedAccepted
    case receivedRejected
    case receivedCanceled

    // MARK: - Properties

    var title: String {
        switch self {
        case .sentPending:
            return "동행 요청을 확인하고 있어요"

        case .sentAccepted:
            return "동행이 수락되었어요"

        case .sentRejected:
            return "아쉽지만 다른 동행을 찾아봐요"

        case .sentCanceled:
            return "취소한 동행 요청이에요"

        case .receivedPending:
            return "동행을 원하는 분이 있어요"

        case .receivedAccepted:
            return "수락한 동행 요청이에요"

        case .receivedRejected:
            return "거절한 동행 요청이에요"

        case .receivedCanceled:
            return "취소된 동행 요청이에요"
        }
    }

    var buttonTitle: String? {
        switch self {
        case .sentAccepted,
             .receivedAccepted:
            return "일정 확정하기"

        case .sentRejected:
            return "확인하기"

        case .receivedPending:
            return "수락하러 가기"

        case .sentPending,
             .sentCanceled,
             .receivedRejected,
             .receivedCanceled:
            return nil
        }
    }

    var icon: UIImage? {
        switch self {
        case .sentAccepted,
             .receivedAccepted:
            return .imgCheckPurple

        case .receivedPending:
            return .peopleIcon

        case .sentPending,
             .sentRejected,
             .sentCanceled,
             .receivedRejected,
             .receivedCanceled:
            return nil
        }
    }

    var iconSize: CGSize {
        switch self {
        case .sentAccepted,
             .receivedAccepted:
            return CGSize(width: 20, height: 20)

        case .receivedPending:
            return CGSize(width: 24, height: 24)

        case .sentPending,
             .sentRejected,
             .sentCanceled,
             .receivedRejected,
             .receivedCanceled:
            return .zero
        }
    }

    var iconTintColor: UIColor? {
        switch self {
        case .receivedPending:
            return .primary40

        case .sentPending,
             .sentAccepted,
             .sentRejected,
             .sentCanceled,
             .receivedAccepted,
             .receivedRejected,
             .receivedCanceled:
            return nil
        }
    }

    var isHighlighted: Bool {
        switch self {
        case .sentAccepted,
             .receivedPending,
             .receivedAccepted:
            return true

        case .sentPending,
             .sentRejected,
             .sentCanceled,
             .receivedRejected,
             .receivedCanceled:
            return false
        }
    }

    var showsActionButton: Bool {
        buttonTitle != nil
    }
}
