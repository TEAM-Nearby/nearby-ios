//
//  CompanionProfileDTO.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

struct UpdateCompanionProfileRequestDTO {
    let nickname: String
    let intro: String?
    let profileImageURL: String?
    let travelStyleKeywords: [String]
}

struct CompanionProfileLegacyResponseDTO: Decodable {
    let profileID: Int
    let nickname: String
    let gender: NearbyGender
    let birthYear: Int?
    let intro: String?
    let profileImageURL: String?
    let travelStyleKeywords: [String]

    enum CodingKeys: String, CodingKey {
        case profileID = "profileId"
        case nickname
        case gender
        case birthYear
        case intro
        case profileImageURL = "profileImageUrl"
        case travelStyleKeywords
    }
}
