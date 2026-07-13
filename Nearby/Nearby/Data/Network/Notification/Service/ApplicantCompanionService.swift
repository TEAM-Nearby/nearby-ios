//
//  ApplicantCompanionService.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

protocol ApplicantCompanionService {
    func fetchResult(applicationId: Int) async throws -> CompanionRequestResultResponseDTO
}

final class DefaultApplicantCompanionService {
    
    // MARK: - Property
    
    private let networkProvider: NetworkProvider
    
    // MARK: - Initializer
    
    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - ApplicantCompanionService

extension DefaultApplicantCompanionService: ApplicantCompanionService {
    func fetchResult(applicationId: Int) async throws -> CompanionRequestResultResponseDTO {
        try await networkProvider.request(
            ApplicantCompanionTarget.fetchResult(applicationId: applicationId),
            responseType: CompanionRequestResultResponseDTO.self
        )
    }
}
