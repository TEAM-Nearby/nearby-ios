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
