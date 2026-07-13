//
//  RecruitCompanionTarget.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

import Alamofire

enum RecruitCompanionTarget {
    case recruitCompanion(RecruitCompanionRequestDTO)
}

extension RecruitCompanionTarget: BaseTargetType {
    var path: String {
        return "/api/companion-posts"
    }

    var method: HTTPMethod { .post }

    var bodyParameters: Parameters? {
        switch self {
        case .recruitCompanion(let request):
            var parameters: Parameters = [
                "place": [
                    "googlePlaceId": request.place.googlePlaceId,
                    "name": request.place.name,
                    "address": request.place.address,
                    "latitude": request.place.latitude,
                    "longitude": request.place.longitude,
                    "category": request.place.category.rawValue
                ],
                "meetingTimeType": request.meetingTimeType.rawValue,
                "maxParticipants": request.maxParticipants,
                "styleKeywords": request.styleKeywords.map(\.rawValue),
                "content": request.content,
                "openChatUrl": request.openChatUrl
            ]

            if let meetingAt = request.meetingAt {
                parameters["meetingAt"] = meetingAt
            }

            return parameters
        }
    }
}
