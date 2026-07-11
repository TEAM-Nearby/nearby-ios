//
//  MatchingMatchedCardContentModel.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

struct MatchingMatchedCardContentModel {
    let profileImage: UIImage?
    let profileImageUrl: String?
    let name: String
    let participantCount: Int
    let gender: String
    let uploadedTime: String
    let place: String
    let meetingTime: String
    let description: String

    init(
        profileImage: UIImage? = nil, profileImageUrl: String? = nil, name: String,
        participantCount: Int, gender: String, uploadedTime: String,
        place: String, meetingTime: String, description: String
    ) {
        self.profileImage = profileImage
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.participantCount = participantCount
        self.gender = gender
        self.uploadedTime = uploadedTime
        self.place = place
        self.meetingTime = meetingTime
        self.description = description
    }
}
