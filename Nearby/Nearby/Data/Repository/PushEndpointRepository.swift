//
//  PushEndpointRepository.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

protocol PushEndpointRepository {
    func register(token: String) async throws
    func unregister() async throws
}

final class DefaultPushEndpointRepository {

    // MARK: - Properties

    private let platform = "IOS"
    private let service: PushEndpointService
    private let installationIDStorage: InstallationIDStorage

    // MARK: - Initializer

    init(service: PushEndpointService, installationIDStorage: InstallationIDStorage) {
        self.service = service
        self.installationIDStorage = installationIDStorage
    }
}

// MARK: - PushEndpointRepository

extension DefaultPushEndpointRepository: PushEndpointRepository {
    func register(token: String) async throws {
        let request = RegisterPushEndpointRequestDTO(
            installationId: installationIDStorage.installationID,
            token: token,
            platform: platform
        )
        _ = try await service.register(request: request)
    }

    func unregister() async throws {
        try await service.unregister(installationId: installationIDStorage.installationID)
    }
}
