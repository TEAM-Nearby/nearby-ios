//
//  CompanionProfileRepository.swift
//  Nearby
//
//  Created by h2e on 10/14/26.
//

import Foundation

protocol CompanionProfileRepository {
    func fetchCompanionProfile(profileID: Int) async throws -> CompanionProfile
    
    func updateCompanionProfile(_ update: CompanionProfileUpdate) async throws -> CompanionProfile

    func uploadProfileImage(data: Data, fileName: String, contentType: String) async throws -> String
}

final class DefaultCompanionProfileRepository {

    // MARK: - Property

    private let service: CompanionProfileService
    private let authService: AuthService

    // MARK: - Initializer

    init(service: CompanionProfileService, authService: AuthService) {
        self.service = service
        self.authService = authService
    }
}

// MARK: - CompanionProfileRepository

extension DefaultCompanionProfileRepository: CompanionProfileRepository {
    func fetchCompanionProfile(profileID: Int) async throws -> CompanionProfile {
        let response = try await service.fetch(profileID: profileID)
        return CompanionProfileMapper.map(response)
    }
    
    func updateCompanionProfile(_ update: CompanionProfileUpdate) async throws -> CompanionProfile {
        let response = try await service.update(request: CompanionProfileMapper.map(update))
        return CompanionProfileMapper.map(response)
    }
    
    func uploadProfileImage(data: Data, fileName: String, contentType: String) async throws -> String {
        let uploadResponse = try await authService.issueProfileImageUploadURL(request: ProfileImageUploadURLRequestDTO(fileName: fileName, contentType: contentType, fileSize: data.count))

        try await authService.uploadProfileImage(data: data, uploadURL: uploadResponse.uploadUrl, headers: uploadResponse.headers)

        return uploadResponse.imageUrl
    }
}
