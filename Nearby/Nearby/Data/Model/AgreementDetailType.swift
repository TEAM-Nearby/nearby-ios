//
//  AgreementDetailType.swift
//  Nearby
//
//  Created by 신서연 on 10/16/26.
//

import Foundation

enum AgreementDetailType {
    case location
    case privacy
    case marketing

    var title: String {
        switch self {
        case .location:
            return "위치 기반 서비스 약관 동의 (필수)"
        case .privacy:
            return "개인정보 수집 약관 동의 (필수)"
        case .marketing:
            return "마케팅 정보 앱 푸시 알림 약관 동의 (선택)"
        }
    }

    var fileName: String {
        switch self {
        case .location:
            return "locationTerms"
        case .privacy:
            return "privacyTerms"
        case .marketing:
            return "marketingTerms"
        }
    }
}
