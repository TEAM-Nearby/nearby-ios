//
//  MatchedCompanion.swift
//  Nearby
//

struct MatchedCompanion {
    let matchID: Int
    let hostNickname: String
    let hostProfileImageURL: String?
    let hostGender: MatchedCompanionGender
    let placeName: String?
    let meetingAt: String?
    let meetingTimeType: MatchedCompanionTimeType
    let createdAt: String
    let content: String
    let matchStatus: MatchedCompanionStatus
}

struct MatchedCompanionPreview {
    let matchID: Int
    let host: Host
    let members: [Member]
    let companionPost: CompanionPost

    struct Host {
        let hostName: String
        let hostProfileImageURL: String?
    }

    struct Member {
        let memberID: Int
        let profileImageURL: String?
        let nickname: String
    }

    struct CompanionPost {
        let postID: Int
        let content: String
        let placeName: String
        let meetingTimeType: MatchedCompanionTimeType
        let meetingAt: String?
    }
}

struct MatchedCompanionScheduleDetail {
    let matchID: Int
    let matchStatus: MatchedCompanionStatus
    let schedule: Schedule?
    let openChatURL: String?
    let userNickname: String?
    let meetingTimeType: MatchedCompanionTimeType
    let currentUserRole: MatchedCompanionUserRole

    struct Schedule {
        let place: Place
        let scheduledAt: String
    }

    struct Place {
        let googlePlaceID: String
        let name: String
        let address: String
        let latitude: Double
        let longitude: Double
    }
}

enum MatchedCompanionGender: String {
    case male = "MALE"
    case female = "FEMALE"
}

enum MatchedCompanionTimeType: String {
    case now = "NOW"
    case scheduled = "SCHEDULED"
    case undecided = "UNDECIDED"
}

enum MatchedCompanionStatus: String {
    case matched = "MATCHED"
    case scheduleConfirmed = "SCHEDULE_CONFIRMED"
    case canceled = "CANCELED"
    case completed = "COMPLETED"
}

enum MatchedCompanionUserRole: String {
    case host = "HOST"
    case participant = "GUEST"
}
