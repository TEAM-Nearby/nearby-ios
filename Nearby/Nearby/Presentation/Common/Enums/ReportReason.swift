//
//  ReportReason.swift
//  Nearby
//
//  Created by h2e on 7/9/26.
//

// MARK: - CaseIterable

enum ReportReason: Int, CaseIterable {
    case inappropriate
    case noShow
    case dangerous
    case moneyRequest
    case extra
    
    var title: String {
        switch self {
        case .inappropriate:
            return "부적절한 언행이나 태도를 했어요"
        case .noShow:
            return "약속 장소에 나타나지 않았어요 (노쇼)"
        case .dangerous:
            return "안전을 위협하거나 위험행동을 했어요"
        case .moneyRequest:
            return "금전 요구를 했어요"
        case .extra:
            return "기타"
        }
    }
}
