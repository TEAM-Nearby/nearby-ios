//
//  PushEndpointService.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

protocol PushEndpointService {
    func register(request: RegisterPushEndpointRequestDTO) async throws -> PushEndpointResponseDTO
    func unregister(installationId: String) async throws
}

final class DefaultPushEndpointService {

    // MARK: - Property

    private let networkProvider: any NetworkProviding

    // MARK: - Initializer

    init(networkProvider: any NetworkProviding) {
        self.networkProvider = networkProvider
    }
}

// MARK: - PushEndpointService

extension DefaultPushEndpointService: PushEndpointService {
    func register(request: RegisterPushEndpointRequestDTO) async throws -> PushEndpointResponseDTO {
        try await networkProvider.request(
            PushEndpointTarget.register(request: request),
            responseType: PushEndpointResponseDTO.self
        )
    }

    func unregister(installationId: String) async throws {
        _ = try await networkProvider.request(
            PushEndpointTarget.unregister(installationId: installationId),
            responseType: String.self
        )
    }
}
