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
    case issueProfileImageUploadURL(ProfileImageUploadURLRequestDTO)
    case createCompanionProfile(CompanionProfileRequestDTO)
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

        case .confirmVerificationCode(let phoneVerificationId,_ ):
            return "/api/onboarding/phone-verifications/\(phoneVerificationId)"

        case .issueProfileImageUploadURL:
            return "/api/onboarding/profile-images/presigned-url"

        case .createCompanionProfile:
            return "/api/onboarding/companion-profiles"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .kakaoLogin,
             .refresh,
             .sendVerificationCode,
             .issueProfileImageUploadURL,
             .createCompanionProfile:
            return .post
            
        case .confirmVerificationCode:
            return .patch
        }
    }

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

        case .issueProfileImageUploadURL(let request):
            return [
                "fileName": request.fileName,
                "contentType": request.contentType,
                "fileSize": request.fileSize
            ]

        case .createCompanionProfile(let request):
            var parameters: Parameters = [
                "nickname": request.nickname,
                "gender": request.gender,
                "travelStyleKeywords": request.travelStyleKeywords
            ]

            if let intro = request.intro {
                parameters["intro"] = intro
            }

            if let profileImageUrl = request.profileImageUrl {
                parameters["profileImageUrl"] = profileImageUrl
            }

            return parameters
        }
    }

    var requiresAuth: Bool {
        switch self {
        case .kakaoLogin, .refresh:
            return false

        case .sendVerificationCode,
             .confirmVerificationCode,
             .issueProfileImageUploadURL,
             .createCompanionProfile:
            return true
        }
    }
}
