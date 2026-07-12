//
//  OnboardingStatus.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

enum OnboardingStatus: String, Decodable {
    case started = "STARTED"
    case phoneVerified = "PHONE_VERIFIED"
    case completed = "COMPLETED"
}
