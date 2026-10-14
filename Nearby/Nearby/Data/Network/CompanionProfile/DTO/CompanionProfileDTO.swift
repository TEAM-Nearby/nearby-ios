//
//  CompanionProfileDTO.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

struct UpdateCompanionProfileRequestDTO {
    let nickname: String
    let intro: String?
    let profileImageUrl: String?
    let travelStyleKeywords: [String]
}

struct CompanionProfileDetailResponseDTO: Decodable {
    let profileId: Int
    let nickname: String
    let gender: NearbyGender
    let birthYear: Int?
    let intro: String?
    let profileImageUrl: String?
    let travelStyleKeywords: [String]
}
