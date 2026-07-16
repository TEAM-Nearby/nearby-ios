//
//  ApplicantCompanionResponseDTO.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

struct CompanionRequestResultResponseDTO: Decodable {
    let applicationId: Int
    let applicationStatus: String
    let acceptedResult: AcceptedResult?
    
    struct AcceptedResult: Decodable {
        let matchId: Int
        let matchStatus: String
        let postId: Int
        let host: Host
        let place: Place
        let meetingTimeType: PostType
        let meetingAt: String?
        let participantCount: Int
        let maxParticipants: Int
        let openChatUrl: String?
    }
    
    struct Host: Decodable {
        let userId: Int
        let nickname: String
        let profileImageUrl: String?
    }
    
    struct Place: Decodable {
        let googlePlaceId: String?
        let name: String
        let address: String?
        let latitude: Double
        let longitude: Double
    }
}
