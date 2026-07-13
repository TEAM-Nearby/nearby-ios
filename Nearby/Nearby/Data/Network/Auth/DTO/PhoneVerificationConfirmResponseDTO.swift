//
//  PhoneVerificationConfirmResponseDTO.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import Foundation

struct PhoneVerificationConfirmResponseDTO: Decodable {
    let phoneVerified: Bool
    let onboardingStatus: String
}