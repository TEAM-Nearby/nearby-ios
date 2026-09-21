//
//  MatchedCompanionListRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol MatchedCompanionListRepository {
    func fetchMatches() async throws -> [MatchedCompanion]
    func fetchMatchPreview(matchId matchID: Int) async throws -> MatchedCompanionPreview
    func fetchMatchMySchedule(matchId matchID: Int) async throws -> MatchedCompanionScheduleDetail
    func confirmSchedule(matchId matchID: Int, scheduledAt: String) async throws
}

final class DefaultMatchedCompanionListRepository {
    
    // MARK: - Property
    
    private let service: MatchedCompanionListService
    
    // MARK: - Initializer
    
    init(service: MatchedCompanionListService) {
        self.service = service
    }
}

// MARK: - MatchedCompanionListRepository

extension DefaultMatchedCompanionListRepository: MatchedCompanionListRepository {
    func fetchMatches() async throws -> [MatchedCompanion] {
        try await service.fetchMatches().matches.map { $0.toModel() }
    }

    func fetchMatchPreview(matchId matchID: Int) async throws -> MatchedCompanionPreview {
        try await service.fetchMatchPreview(matchId: matchID).toModel()
    }

    func fetchMatchMySchedule(matchId matchID: Int) async throws -> MatchedCompanionScheduleDetail {
        try await service.fetchMatchMySchedule(matchId: matchID).toModel()
    }

    func confirmSchedule(matchId matchID: Int, scheduledAt: String) async throws {
        _ = try await service.confirmSchedule(matchId: matchID, request: ConfirmCompanionScheduleRequestDTO(scheduledAt: scheduledAt))
    }
}

// MARK: - DTO Mapping

private extension MatchedCompanionListResponseDTO.Match {
    func toModel() -> MatchedCompanion {
        MatchedCompanion(
            matchID: matchId, hostNickname: hostNickname, hostProfileImageURL: hostProfileImageUrl,
            hostGender: hostGender.toModel(), placeName: placeName, meetingAt: meetingAt,
            meetingTimeType: meetingTimeType.toMatchedCompanionModel(), createdAt: createdAt, content: content,
            matchStatus: matchStatus.toModel()
        )
    }
}

private extension MatchedCompanionPreviewResponseDTO {
    func toModel() -> MatchedCompanionPreview {
        MatchedCompanionPreview(
            matchID: matchId,
            host: MatchedCompanionPreview.Host(hostName: host.hostName, hostProfileImageURL: host.hostProfileImageUrl),
            members: members.map {
                MatchedCompanionPreview.Member(memberID: $0.memberId, profileImageURL: $0.profileImageUrl, nickname: $0.nickname)
            },
            companionPost: MatchedCompanionPreview.CompanionPost(
                postID: companionPost.postId, content: companionPost.content, placeName: companionPost.placeName,
                meetingTimeType: companionPost.meetingTimeType.toMatchedCompanionModel(), meetingAt: companionPost.meetingAt
            )
        )
    }
}

private extension MatchMyScheduleResponseDTO {
    func toModel() -> MatchedCompanionScheduleDetail {
        MatchedCompanionScheduleDetail(
            matchID: matchId, matchStatus: matchStatus.toModel(),
            schedule: schedule.map {
                MatchedCompanionScheduleDetail.Schedule(
                    place: MatchedCompanionScheduleDetail.Place(
                        googlePlaceID: $0.place.googlePlaceId, name: $0.place.name, address: $0.place.address,
                        latitude: $0.place.latitude, longitude: $0.place.longitude
                    ),
                    scheduledAt: $0.scheduledAt
                )
            },
            openChatURL: openChatUrl, userNickname: userNickname,
            meetingTimeType: meetingTimeType.toMatchedCompanionModel(), currentUserRole: currentUserRole.toModel()
        )
    }
}

private extension HostGender {
    func toModel() -> MatchedCompanionGender {
        switch self {
        case .male: .male
        case .female: .female
        }
    }
}

private extension MeetingTimeType {
    func toMatchedCompanionModel() -> MatchedCompanionTimeType {
        switch self {
        case .now: .now
        case .scheduled: .scheduled
        case .undecided: .undecided
        }
    }
}

private extension MatchStatus {
    func toModel() -> MatchedCompanionStatus {
        switch self {
        case .matched: .matched
        case .scheduleConfirmed: .scheduleConfirmed
        case .canceled: .canceled
        case .completed: .completed
        }
    }
}

private extension MatchMyScheduleResponseDTO.UserRole {
    func toModel() -> MatchedCompanionUserRole {
        switch self {
        case .host: .host
        case .participant: .participant
        }
    }
}
