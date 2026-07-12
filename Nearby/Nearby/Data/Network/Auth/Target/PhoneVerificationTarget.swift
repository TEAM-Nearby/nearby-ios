//
//  PhoneVerificationTarget.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import Alamofire

enum PhoneVerificationTarget {
    case sendVerificationCode(PhoneVerificationRequestDTO)
}

// MARK: - BaseTargetType

extension PhoneVerificationTarget: BaseTargetType {
    var path: String {
        switch self {
        case .sendVerificationCode:
            return "/api/onboarding/phone-verifications"
        }
    }

    var method: HTTPMethod {
        .post
    }

    var bodyParameters: Parameters? {
        switch self {
        case .sendVerificationCode(let request):
            return [
                "phoneNumber": request.phoneNumber
            ]
        }
    }
}
