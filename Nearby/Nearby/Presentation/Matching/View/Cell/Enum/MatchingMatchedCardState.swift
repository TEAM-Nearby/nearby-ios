//
//  MatchingMatchedCardState.swift
//  Nearby
//
//  Created by 장지인 on 7/9/26.
//

import UIKit

enum MatchingMatchedCardState {
    case pending
    case confirmed

    var backgroundColor: UIColor {
        switch self {
        case .pending:
            return .bgSurfaceGrey0
        case .confirmed:
            return .primary5
        }
    }

    var showsConfirmedLabel: Bool {
        switch self {
        case .pending:
            return false
        case .confirmed:
            return true
        }
    }
}
