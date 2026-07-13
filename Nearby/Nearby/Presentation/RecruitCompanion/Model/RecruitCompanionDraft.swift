//
//  RecruitCompanionDraft.swift
//  Nearby
//
//  Created by 장지인 on 7/12/26.
//

import Foundation

struct RecruitCompanionDraft {
    var meetingTimeType: RecruitMeetingTimeType = .now
    var meetingAt: Date?
    var maxParticipants = 2
    var styleKeywords = Set<String>()
    var placeQuery = ""
    var selectedPlaceID: String?
    var selectedPlaceAddress = ""
    var selectedPlaceLatitude: Double?
    var selectedPlaceLongitude: Double?
    var selectedPlaceCategory = PlaceCategory.other.rawValue
    var content = ""
    var openChatURL = ""
}
