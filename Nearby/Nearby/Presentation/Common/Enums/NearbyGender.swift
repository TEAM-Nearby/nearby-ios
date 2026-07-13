//
//  NearbyGender.swift
//  Nearby
//
//  Created by 신서연 on 7/8/26.
//

import Foundation

enum NearbyGender: String, Decodable {
    case male = "MALE"
    case female = "FEMALE"
    
    var genderDisplayText: String {
        switch self {
        case .female:
            return "여성"
        case .male:
            return "남성"
        }
    }
}
