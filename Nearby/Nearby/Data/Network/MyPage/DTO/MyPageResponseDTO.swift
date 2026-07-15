//
//  MyPageResponseDTO.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Foundation

struct MyPageResponseDTO: Decodable {
    let profileImageUrl: String?
    let nickname: String
    let isPhoneVerified: Bool
    let ageGroup: MyPageAgeGroup?
    let gender: NearbyGender
    let mannerScore: Double
    let mannerKeywords: [String]
    let travelStyleKeywords: [String]
    let mealTogetherCount: Int
    let visitedCityCount: Int
    let receivedReviewCount: Int
}

struct MyCompanionPostsResponseDTO: Decodable {
    let posts: [MyCompanionPostDTO]
}

struct MyCompanionPostDTO: Decodable {
    let postId: Int
    let cityName: String
    let scheduledAt: String?
    let place: MyCompanionPostPlaceDTO
    let hostProfileImageUrl: String?
    let members: [MyCompanionPostMemberDTO]
    let currentParticipants: Int
    let maxParticipants: Int
    let content: String
    let reviewKeywords: [String]
}

struct MyCompanionPostMemberDTO: Decodable {
    let userId: Int
    let profileImageUrl: String?
}

struct MyCompanionPostPlaceDTO: Decodable {
    let googlePlaceId: String
    let name: String
    let latitude: Double?
    let longitude: Double?
}

enum MyPageAgeGroup: String, Decodable {
    case teens = "TEENS"
    case twenties = "TWENTIES"
    case thirties = "THIRTIES"
    case forties = "FORTIES"
    case fifties = "FIFTIES"
    case sixtiesOrAbove = "SIXTIES_OR_ABOVE"

    var displayText: String {
        switch self {
        case .teens:
            return "10대"

        case .twenties:
            return "20대"

        case .thirties:
            return "30대"

        case .forties:
            return "40대"

        case .fifties:
            return "50대"

        case .sixtiesOrAbove:
            return "60대 이상"
        }
    }
}
