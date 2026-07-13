//
//  PhoneVerificationTarget.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import Alamofire

enum PhoneVerificationTarget {
    case sendVerificationCode(PhoneVerificationRequestDTO)
    case confirmVerificationCode(phoneVerificationId: Int, request: PhoneVerificationConfirmRequestDTO)
}

// MARK: - BaseTargetType

extension PhoneVerificationTarget: BaseTargetType {

    var path: String {
        switch self {
        case .sendVerificationCode:
            return "/api/onboarding/phone-verifications"

        case .confirmVerificationCode(let phoneVerificationId, _):
            return "/api/onboarding/phone-verifications/\(phoneVerificationId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .sendVerificationCode:
            return .post

        case .confirmVerificationCode:
            return .patch
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .sendVerificationCode(let request):
            return ["phoneNumber": request.phoneNumber]

        case .confirmVerificationCode(_, let request):
            return ["verificationCode": request.verificationCode]
        }
    }
}
