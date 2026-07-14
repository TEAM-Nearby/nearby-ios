//
//  ReviewKeyword.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

enum ReviewKeyword: String {
    case fastResponse = "FAST_RESPONSE"
    case goodManners = "GOOD_MANNERS"
    case goodConversation = "GOOD_CONVERSATION"
    case goodTalker = "GOOD_TALKER"
    case informative = "INFORMATIVE"
    case punctual = "PUNCTUAL"
    case notifyDelayInAdvance = "NOTIFY_DELAY_IN_ADVANCE"
    case arrivesEarly = "ARRIVES_EARLY"

    static let consideration: [ReviewKeyword] = [
        .fastResponse, .goodManners, .goodConversation, .goodTalker, .informative
    ]

    static let timePromise: [ReviewKeyword] = [
        .punctual, .notifyDelayInAdvance, .arrivesEarly
    ]

    var displayText: String {
        switch self {
        case .fastResponse: return "연락이 빨라요"
        case .goodManners: return "매너가 좋아요"
        case .goodConversation: return "대화가 잘 통해요"
        case .goodTalker: return "입담이 좋아요"
        case .informative: return "유용한 정보를 많이 알아요"
        case .punctual: return "시간 약속을 잘 지켜요"
        case .notifyDelayInAdvance: return "늦어도 미리 알려줘요"
        case .arrivesEarly: return "약속 시간보다 일찍 와요"
        }
    }
}
