//
//  MeetingStep.swift
//  Nearby
//
//  Created by h2e on 7/8/26.
//

import UIKit

enum MeetingStep: Int, CaseIterable {
    case match = 1
    case verification = 2
    case completion = 3
    
    var stepTitle: String {
        "\(rawValue)/3"
    }
    
    var stepDescription: String {
        switch self {
        case .match, .verification:
            return "만남 인증 단계예요"
        case .completion:
            return "동행 단계예요"
        }
    }
    
    var progressBarImage: UIImage {
        switch self {
        case .match, .verification:
            return .indicatorStep2
        case .completion:
            return .indicatorStep3
        }
    }
}
