//
//  MatchingMatchedCardDisplayMode.swift
//  Nearby
//
//  Created by 장지인 on 7/10/26.
//

import UIKit

enum MatchingMatchedCardDisplayMode {
    case list
    case scheduleDetail

    var descriptionColor: UIColor {
        switch self {
        case .list:
            return .grey30
        case .scheduleDetail:
            return .grey40
        }
    }

    func cardBackgroundColor(state: MatchingMatchedCardState) -> UIColor {
        switch self {
        case .list:
            return state.backgroundColor
        case .scheduleDetail:
            return .bgSurfaceGrey0
        }
    }

    func showsConfirmedLabel(state: MatchingMatchedCardState) -> Bool {
        switch self {
        case .list:
            return state.showsConfirmedLabel
        case .scheduleDetail:
            return false
        }
    }
}
