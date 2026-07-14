//
//  AuthRequestDTO.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

struct KakaoLoginRequestDTO: Encodable {
    let idToken: String
    let nonce: String
}

struct TokenRefreshRequestDTO: Encodable {
    let refreshToken: String
}

struct PhoneVerificationConfirmRequestDTO: Encodable {
    let verificationCode: String
}

struct PhoneVerificationRequestDTO: Encodable {
    let phoneNumber: String
}
