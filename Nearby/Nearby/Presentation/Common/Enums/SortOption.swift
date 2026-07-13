//
//  SortOption.swift
//  Nearby
//
//  Created by soomin on 7/9/26.
//

enum SortOption: CaseIterable {
    case latest
    case nearest
    case closingSoon

    var title: String {
        switch self {
        case .latest:
            return "최신순"
        case .nearest:
            return "가까운 순"
        case .closingSoon:
            return "마감 임박"
        }
    }

    var serverKey: String {
        switch self {
        case .latest:
            return "LATEST"
        case .nearest:
            return "DISTANCE"
        case .closingSoon:
            return "CLOSING_SOON"
        }
    }
}
