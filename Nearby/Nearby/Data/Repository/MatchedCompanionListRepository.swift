//
//  MatchedCompanionListRepository.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol MatchedCompanionListRepository {
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO
    func fetchMatchDetail(matchId: Int) async throws -> MatchingScheduleDetailResponseModel
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

    func fetchMatchDetail(matchId: Int) async throws -> MatchingScheduleDetailResponseModel {
        try await service.fetchMatchDetail(matchId: matchId)
    }
}
