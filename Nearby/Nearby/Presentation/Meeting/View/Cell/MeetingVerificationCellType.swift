//
//  MeetingVerificationCellType.swift
//  Nearby
//
//  Created by h2e on 7/6/26.
//

enum MeetingVerificationCellType {
    case verifiable
    case notYet
    
    var showsVerifyView: Bool {
        switch self {
        case .verifiable: return true
        case .notYet: return false
        }
    }
}
