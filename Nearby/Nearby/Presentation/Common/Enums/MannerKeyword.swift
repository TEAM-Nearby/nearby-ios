//
//  MannerKeyword.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

enum MannerKeyword: String {
    case fastResponse = "FAST_RESPONSE"
    case goodManners = "GOOD_MANNERS"
    case goodConversation = "GOOD_CONVERSATION"
    case goodTalker = "GOOD_TALKER"
    case informative = "INFORMATIVE"
    case punctual = "PUNCTUAL"
    case notifyDelayInAdvance = "NOTIFY_DELAY_IN_ADVANCE"
    case arrivesEarly = "ARRIVES_EARLY"

    var category: Category {
        switch self {
        case .fastResponse, .goodManners, .goodConversation, .goodTalker, .informative:
            return .communication
        case .punctual, .notifyDelayInAdvance, .arrivesEarly:
            return .punctuality
        }
    }

    var title: String {
        switch self {
        case .fastResponse:
            return "답장이 빨라요"

        case .goodManners:
            return "매너가 좋아요"

        case .goodConversation:
            return "대화가 잘 통해요"

        case .goodTalker:
            return "대화를 잘 이끌어요"

        case .informative:
            return "정보를 잘 알려줘요"

        case .punctual:
            return "약속 시간을 잘 지켜요"

        case .notifyDelayInAdvance:
            return "늦을 때 미리 알려줘요"

        case .arrivesEarly:
            return "약속 장소에 일찍 도착해요"
        }
    }

    static func titles(for serverKeys: [String]) -> [String] {
        serverKeys.map { serverKey in
            MannerKeyword(rawValue: serverKey)?.title ?? serverKey
        }
    }

    enum Category {
        case communication
        case punctuality
    }
}
