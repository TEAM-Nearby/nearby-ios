//
//  ApplicantCompanionRepository.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

protocol ApplicantCompanionRepository {
    func fetchRequestResult(applicationId: Int) async throws -> CompanionRequestResultResponseDTO
}

final class DefaultApplicantCompanionRepository {
    
    // MARK: - Property
    
    private let applicantCompanionService: ApplicantCompanionService
    
    // MARK: - Initializer
    
    init(applicantCompanionService: ApplicantCompanionService) {
        self.applicantCompanionService = applicantCompanionService
    }
}

// MARK: - ApplicantCompanionRepository

extension DefaultApplicantCompanionRepository: ApplicantCompanionRepository {
    func fetchRequestResult(applicationId: Int) async throws -> CompanionRequestResultResponseDTO {
        try await applicantCompanionService.fetchResult(applicationId: applicationId)
    }
}
