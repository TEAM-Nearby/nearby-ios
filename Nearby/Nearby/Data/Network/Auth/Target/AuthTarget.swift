//
//  AuthTarget.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Alamofire

enum AuthTarget {
    case kakaoLogin(KakaoLoginRequestDTO)
    case refresh(TokenRefreshRequestDTO)
    case sendVerificationCode(PhoneVerificationRequestDTO)
    case confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO)
}

extension AuthTarget: BaseTargetType {
    var path: String {
        switch self {
        case .kakaoLogin: 
            return "/api/kakao/login"
        case .refresh: 
            return "/api/auth/refresh"
        case .sendVerificationCode:
            return "/api/onboarding/phone-verifications"
        case .confirmVerificationCode(let phoneVerificationId, _):
            return "/api/onboarding/phone-verifications/\(phoneVerificationId)"
        }
    }

    var method: HTTPMethod { .post }

    var bodyParameters: Parameters? {
        switch self {
        case .kakaoLogin(let request):
            return ["idToken": request.idToken, "nonce": request.nonce]
        case .refresh(let request):
            return ["refreshToken": request.refreshToken]
        case .sendVerificationCode(let request):
            return ["phoneNumber": request.phoneNumber]
        case .confirmVerificationCode(_, let request):
            return ["verificationCode": request.verificationCode]
        }
    }

    var requiresAuth: Bool { false }
}
