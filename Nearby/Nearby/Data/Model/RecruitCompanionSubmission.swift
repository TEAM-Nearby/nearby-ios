//
//  RecruitCompanionSubmission.swift
//  Nearby
//
//  Created by 장지인 on 9/21/26.
//

import Foundation

struct RecruitCompanionSubmission {
    let place: SelectedPlace
    let meetingAt: Date?
    let maxParticipants: Int
    let styleKeywords: [RecruitCompanionStyleKeyword]
    let content: String
    let openChatURL: String
}
