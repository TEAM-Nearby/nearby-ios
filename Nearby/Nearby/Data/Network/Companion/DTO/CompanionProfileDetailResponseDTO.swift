//
//  CompanionProfileDetailResponseDTO.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

struct CompanionProfileDetailResponseDTO: Decodable {
    let profileId: Int
    let userId: Int
    let nickname: String
    let gender: NearbyGender
    let birthYear: Int?
    let profileImageUrl: String?
    let intro: String?
    let keywords: [String]
}

struct UpdateCompanionProfileResponseDTO: Decodable {
    let profileId: Int
    let nickname: String
    let gender: NearbyGender
    let birthYear: Int?
    let profileImageUrl: String?
    let intro: String?
    let travelStyleKeywords: [String]
}
