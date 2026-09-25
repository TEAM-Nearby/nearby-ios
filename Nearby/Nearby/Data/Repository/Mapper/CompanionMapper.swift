//
//  CompanionMapper.swift
//  Nearby
//
//  Created by soomin on 9/21/26.
//

import Foundation

enum CompanionMapper {
    static func map(_ response: CompanionListResponseDTO) -> CompanionList {
        var posts: [CompanionPost] = []
        for dto in response.posts {
            posts.append(map(dto))
        }

        return CompanionList(summaryText: response.summaryText, posts: posts)
    }
}

extension CompanionMapper {
    static func map(_ dto: CompanionDTO) -> CompanionPost {
        CompanionPost(
            postId: dto.postId,
            host: CompanionHost(
                nickname: dto.host.nickname,
                gender: mapGender(dto.host.gender)
            ),
            place: CompanionPlace(
                placeId: dto.place.placeId,
                googlePlaceId: dto.place.googlePlaceId,
                name: dto.place.name,
                category: mapCategory(dto.place.category),
                latitude: dto.place.latitude,
                longitude: dto.place.longitude,
                distanceMeters: dto.place.distanceMeters,
                imageURL: URL(string: dto.place.imageUrl),
                usesDefaultImage: dto.place.imageSource == "DEFAULT"
            ),
            contentPreview: dto.contentPreview,
            meetingTimeType: mapMeetingTimeType(dto.meetingTimeType),
            meetingAt: CompanionDateParser.parse(dto.meetingAt),
            meetingAtText: dto.meetingAtText,
            participantCount: dto.participantCount,
            participants: dto.participants.map {
                CompanionParticipant(userId: $0.userId, profileImageURL: $0.profileImageUrl)
            },
            participantSummaryText: dto.participantSummaryText,
            createdAt: CompanionDateParser.parse(dto.createdAt),
            createdAgoText: dto.createdAgoText
        )
    }

    static func mapGender(_ value: String) -> CompanionHost.Gender {
        switch value {
        case "FEMALE": .female
        case "MALE": .male
        default: .unknown
        }
    }

    static func mapCategory(_ value: String) -> CompanionPlace.Category {
        switch value {
        case "RESTAURANT": .restaurant
        case "CAFE": .cafe
        case "PUB": .pub
        case "MUSEUM": .museum
        case "PHOTO_SPOT": .photoSpot
        default: .unknown
        }
    }

    static func mapMeetingTimeType(_ value: String) -> CompanionMeetingTimeType {
        switch value {
        case "NOW": .now
        case "SCHEDULED": .scheduled
        case "UNDECIDED": .undecided
        default: .unknown
        }
    }
}

enum CompanionDateParser {
    static func parse(_ value: String?) -> Date? {
        guard let value else { return nil }

        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: value) {
            return date
        }

        let localFormatter = DateFormatter()
        localFormatter.locale = Locale(identifier: "en_US_POSIX")
        localFormatter.timeZone = .nearbyAPITimeZone

        for dateFormat in ["yyyy-MM-dd'T'HH:mm:ss.SSSSSS", "yyyy-MM-dd'T'HH:mm:ss.SSS", "yyyy-MM-dd'T'HH:mm:ss", "yyyy-MM-dd'T'HH:mm"] {
            localFormatter.dateFormat = dateFormat
            if let date = localFormatter.date(from: value) {
                return date
            }
        }

        return nil
    }
}
