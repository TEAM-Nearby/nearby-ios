//
//  Nearby.swift
//  Nearby
//
//  Created by 신서연 on 7/6/26.
//

import UIKit

enum NearbyNavigationBarItem: Equatable {
    case back
    case down
    case alarm
    case alarmDot
    case alarmPoint
    case setting
    case alarmButton
    case report
    case logo
    case title(String)
    case empty
}

extension NearbyNavigationBarItem {
    var image: UIImage? {
        switch self {
        case .back:
            return .chevronLeftIcon
        case .down:
            return .chevronDownIcon
        case .alarm:
            return .alarmIcon
        case .alarmDot:
            return .alarmIconDot.withRenderingMode(.alwaysOriginal)
        case .setting:
            return .settingIcon
        case .alarmButton:
            return .icAlarmBtn.withRenderingMode(.alwaysOriginal)
        case .alarmPoint:
            return .icAlarmBtnRed.withRenderingMode(.alwaysOriginal)
        default:
            return nil
        }
    }

    var text: String? {
        switch self {
        case .title(let text):
            return text
        case .report:
            return "신고"
        default:
            return nil
        }
    }
}
