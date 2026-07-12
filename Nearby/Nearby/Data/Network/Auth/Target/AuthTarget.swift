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
}

extension AuthTarget: BaseTargetType {
    var path: String {
        switch self {
        case .kakaoLogin: return "/api/kakao/login"
        case .refresh: return "/api/auth/refresh"
        }
    }

    var method: HTTPMethod { .post }

    var bodyParameters: Parameters? {
        switch self {
        case .kakaoLogin(let request):
            return ["idToken": request.idToken, "nonce": request.nonce]
        case .refresh(let request):
            return ["refreshToken": request.refreshToken]
        }
    }

    var requiresAuth: Bool { false }
}
