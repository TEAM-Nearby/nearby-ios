//
//  RecruitCompanionStyleKeyword.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

enum RecruitCompanionStyleKeyword: String, Codable, CaseIterable {
    case photoLover = "PHOTO_LOVER"
    case goodReactor = "GOOD_REACTOR"
    case calm = "CALM"
    case infoSharingWelcome = "INFO_SHARING_WELCOME"
    case newFoodChallenge = "NEW_FOOD_CHALLENGE"
    case powerJ = "POWER_J"
    case powerP = "POWER_P"
    case foodSharingAvailable = "FOOD_SHARING_AVAILABLE"
    case drinkAvailable = "DRINK_AVAILABLE"

    var title: String {
        switch self {
        case .photoLover:
            return "사진에 진심인"
        case .goodReactor:
            return "리액션이 좋은"
        case .calm:
            return "차분한 성격"
        case .infoSharingWelcome:
            return "정보 공유 환영"
        case .newFoodChallenge:
            return "새로운 음식 도전"
        case .powerJ:
            return "파워 J형"
        case .powerP:
            return "파워 P형"
        case .foodSharingAvailable:
            return "음식 쉐어 가능"
        case .drinkAvailable:
            return "술 한잔 가능"
        }
    }
}
