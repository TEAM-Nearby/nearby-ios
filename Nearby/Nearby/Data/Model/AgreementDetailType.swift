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
    case service
    case restrictionPolicy
    case communityGuide

    var title: String {
        switch self {
        case .location:
            return "위치 기반 서비스 약관 동의 (필수)"
        case .privacy:
            return "개인정보 수집 약관 동의 (필수)"
        case .marketing:
            return "마케팅 정보 앱 푸시 알림 약관 동의 (선택)"
        case .service:
            return "서비스 이용약관"
        case .restrictionPolicy:
            return "Nearby 이용자 제재 운영정책"
        case .communityGuide:
            return "Nearby 커뮤니티 가이드라인 및 안전 가이드"
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
        case .service:
            return "serviceTerms"
        case .restrictionPolicy:
            return "restrictionPolicy"
        case .communityGuide:
            return "communityGuide"
        }
    }
    
    var settingsTitle: String {
        switch self {
        case .service:
            return "서비스 이용약관"
        case .location:
            return "위치 기반 서비스 약관"
        case .privacy:
            return "개인정보 수집 약관"
        case .marketing:
            return "마케팅 정보 앱 푸시 알림 약관"
        case .restrictionPolicy:
            return "Nearby 이용자 제재 운영정책"
        case .communityGuide:
            return "Nearby 커뮤니티 가이드라인 및 안전 가이드"
        }
    }

    static let settingsItems: [AgreementDetailType] = [.service, .location, .privacy, .marketing, .restrictionPolicy, .communityGuide]
}
