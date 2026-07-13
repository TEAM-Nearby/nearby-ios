//
//  ReviewResponseDTO.swift
//  Nearby
//
//  Created by h2e on 7/14/26.
//

struct CreateReviewResponseDTO: Decodable {
    let meetingId: Int
    let reviewId: Int
    let meetingStatus: String
}
