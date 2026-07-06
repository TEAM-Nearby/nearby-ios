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
            return UIImage(named: "chevron_left_icon")
        case .down:
            return UIImage(named: "chevron_down_icon")
        case .alarm:
            return UIImage(named: "alarm_icon")
        case .setting:
            return UIImage(named: "setting_icon")
        case .alarmButton:
            return UIImage(named: "ic_alarm_btn")
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
        case .logo:
            return "Nearby 로고"
        default:
            return nil
        }
    }
}
