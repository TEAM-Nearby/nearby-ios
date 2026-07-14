//
//  MatchedCompanionListService.swift
//  Nearby
//
//  Created by 장지인 on 7/13/26.
//

protocol MatchedCompanionListService {
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO
    func fetchMatchMySchedule(matchId: Int) async throws -> MatchMyScheduleResponseDTO
    func fetchMatchPreview(matchId: Int) async throws -> MatchedCompanionPreviewResponseDTO
}

final class DefaultMatchedCompanionListService {
    
    // MARK: - Property
    
    private let networkProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - MatchedCompanionListService

extension DefaultMatchedCompanionListService: MatchedCompanionListService {
    func fetchMatches() async throws -> MatchedCompanionListResponseDTO {
        try await networkProvider.request(
            MatchedCompanionListTarget.matches,
            responseType: MatchedCompanionListResponseDTO.self
        )
    }

    func fetchMatchDetail(matchId: Int) async throws -> MatchingScheduleDetailResponseModel {
        try await networkProvider.request(
            MatchedCompanionListTarget.detail(matchId: matchId),
            responseType: MatchingScheduleDetailResponseModel.self
        )
    }
}
