//
//  MatchedCompanionListRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol MatchedCompanionListRepository {
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO
    func fetchMatchPreview(matchId: Int) async throws -> MatchedCompanionPreviewResponseDTO
    func fetchMatchMySchedule(matchId: Int) async throws -> MatchMyScheduleResponseDTO
    func confirmSchedule(
        matchId: Int,
        request: ConfirmCompanionScheduleRequestDTO
    ) async throws -> ConfirmCompanionScheduleResponseDTO
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
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO {
        try await service.fetchMatches()
    }

    func fetchMatchPreview(matchId: Int) async throws -> MatchedCompanionPreviewResponseDTO {
        try await service.fetchMatchPreview(matchId: matchId)
    }

    func fetchMatchMySchedule(matchId: Int) async throws -> MatchMyScheduleResponseDTO {
        try await service.fetchMatchMySchedule(matchId: matchId)
    }

    func confirmSchedule(
        matchId: Int,
        request: ConfirmCompanionScheduleRequestDTO
    ) async throws -> ConfirmCompanionScheduleResponseDTO {
        try await service.confirmSchedule(matchId: matchId, request: request)
    }
}
