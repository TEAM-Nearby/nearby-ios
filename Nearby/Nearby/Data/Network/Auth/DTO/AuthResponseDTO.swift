//
//  AuthResponseDTO.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

struct KakaoLoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let refreshTokenExpiresIn: Int
    let userId: Int
    let onboardingStatus: OnboardingStatus
}

struct TokenRefreshResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let refreshTokenExpiresIn: Int
}

struct PhoneVerificationConfirmResponseDTO: Decodable {
    let phoneVerified: Bool
    let onboardingStatus: OnboardingStatus
}

struct PhoneVerificationResponseDTO: Decodable {
    let phoneVerificationId: Int
    let expiresIn: Int
}

struct ProfileImageUploadURLResponseDTO: Decodable {
    let uploadUrl: String
    let imageUrl: String
    let method: String
    let expiresIn: Int
    let headers: [String: String]
}

struct CompanionProfileResponseDTO: Decodable {
    let profileId: Int
    let nickname: String
    let gender: String
    let intro: String?
    let profileImageUrl: String?
    let travelStyleKeywords: [String]
    let onboardingStatus: OnboardingStatus
}
