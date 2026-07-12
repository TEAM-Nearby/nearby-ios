//
//  PhoneVerificationResponseDTO.swift
//  Nearby
//
//  Created by 신서연 on 7/13/26.
//

import Foundation

struct PhoneVerificationResponseDTO: Decodable {
    let phoneVerificationId: Int
    let expiresIn: Int
}
