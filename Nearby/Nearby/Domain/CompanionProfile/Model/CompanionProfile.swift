//
//  CompanionProfile.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

struct CompanionProfile {
    let profileID: Int
    let nickname: String
    let gender: NearbyGender
    let birthYear: Int?
    let intro: String?
    let profileImageURL: String?
    let travelStyleKeywords: [TravelStyleKeyword]
}

struct CompanionProfileUpdate {
    let nickname: String
    let intro: String?
    let profileImageURL: String?
    let travelStyleKeywords: [TravelStyleKeyword]
}
