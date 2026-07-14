//
//  MatchedCompanionListRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol MatchedCompanionListRepository {
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO
    func fetchMatchMySchedule(matchId: Int) async throws -> MatchMyScheduleResponseDTO
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

    func fetchMatchMySchedule(matchId: Int) async throws -> MatchMyScheduleResponseDTO {
        try await service.fetchMatchMySchedule(matchId: matchId)
    }
}
