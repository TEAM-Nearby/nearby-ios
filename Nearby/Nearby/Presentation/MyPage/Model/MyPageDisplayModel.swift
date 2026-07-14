//
//  MyPageDisplayModel.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

struct MyPageDisplayModel {

    // MARK: - Properties

    let profileImageUrl: String?
    let nickname: String
    let genderText: String
    let isPhoneVerified: Bool
    let mannerRating: Int
    let mannerKeywords: [String]
    let travelStyleKeywords: [String]
    let mealTogetherCountText: String
    let visitedCityCountText: String
    let receivedReviewCountText: String

    // MARK: - Initializer

    init(response: MyPageResponseDTO) {
        profileImageUrl = response.profileImageUrl
        nickname = response.nickname
        genderText = response.gender.genderDisplayText
        isPhoneVerified = response.isPhoneVerified

        mannerRating = Int(response.mannerScore.rounded())

        mannerKeywords = MannerKeyword.titles(
            for: response.mannerKeywords
        )

        travelStyleKeywords = TravelStyleKeyword.titles(
            for: response.travelStyleKeywords
        )

        mealTogetherCountText = "\(response.mealTogetherCount)회"
        visitedCityCountText = "\(response.visitedCityCount)곳"
        receivedReviewCountText = "\(response.receivedReviewCount)개"
    }
}
