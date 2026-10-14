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
            profileImageUrl: update.profileImageURL,
            travelStyleKeywords: update.travelStyleKeywords.map(\.rawValue)
        )
    }

    static func map(_ dto: CompanionProfileDetailResponseDTO) -> CompanionProfile {
        CompanionProfile(
            profileID: dto.profileId,
            nickname: dto.nickname,
            gender: dto.gender,
            birthYear: dto.birthYear,
            intro: dto.intro,
            profileImageURL: dto.profileImageUrl,
            travelStyleKeywords: dto.travelStyleKeywords.compactMap(TravelStyleKeyword.init(rawValue:))
        )
    }
}
