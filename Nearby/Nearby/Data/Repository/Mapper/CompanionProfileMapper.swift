//
//  CompanionProfileMapper.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

enum CompanionProfileMapper {
    static func map(_ update: CompanionProfileUpdate) -> UpdateCompanionProfileRequestDTO {
        UpdateCompanionProfileRequestDTO(
            nickname: update.nickname,
            intro: update.intro,
            profileImageURL: update.profileImageURL,
            travelStyleKeywords: update.travelStyleKeywords.map(\.rawValue)
        )
    }
    
    static func map(_ response: CompanionProfileDetailResponseDTO) -> CompanionProfile {
        CompanionProfile(
            profileID: response.profileId,
            nickname: response.nickname,
            gender: response.gender,
            birthYear: response.birthYear,
            intro: response.intro,
            profileImageURL: response.profileImageUrl,
            travelStyleKeywords: response.keywords.compactMap {
                TravelStyleKeyword(rawValue: $0)
            }
        )
    }
    
    static func map(_ response: UpdateCompanionProfileResponseDTO) -> CompanionProfile {
        CompanionProfile(profileID: response.profileId, nickname: response.nickname, gender: response.gender, birthYear: response.birthYear, intro: response.intro, profileImageURL: response.profileImageUrl, travelStyleKeywords: response.travelStyleKeywords.compactMap {TravelStyleKeyword(rawValue: $0)})
    }
}
