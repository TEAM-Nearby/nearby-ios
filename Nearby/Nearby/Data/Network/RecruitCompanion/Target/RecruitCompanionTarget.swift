//
//  RecruitCompanionTarget.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

import Foundation

import Alamofire

enum RecruitCompanionTarget {
    case searchPlaces(PlaceSearchQuery)
    case recruitCompanion(RecruitCompanionRequestDTO)
}

struct PlaceSearchQuery {
    let query: String
    let latitude: Double
    let longitude: Double
    let radiusMeters: Int
    let languageCode: String
    let pageSize: Int
}

extension RecruitCompanionTarget: BaseTargetType {
    var path: String {
        switch self {
        case .searchPlaces:
            return "/api/companion-places/search"
        case .recruitCompanion:
            return "/api/companion-posts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .searchPlaces:
            return .get
        case .recruitCompanion:
            return .post
        }
    }

    var queryParameters: Parameters? {
        switch self {
        case .searchPlaces(let request):
            return [
                "query": request.query,
                "latitude": request.latitude,
                "longitude": request.longitude,
                "radiusMeters": request.radiusMeters,
                "languageCode": request.languageCode,
                "pageSize": request.pageSize
            ]
        case .recruitCompanion:
            return nil
        }
    }

    var bodyParameters: Parameters? {
        switch self {
        case .searchPlaces:
            return nil
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
