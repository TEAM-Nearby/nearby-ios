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
    private var lastTask: Task<Void, Error>?

    // MARK: - Initializer

    init(service: PushEndpointService, installationIDStorage: InstallationIDStorage) {
        self.service = service
        self.installationIDStorage = installationIDStorage
    }

    // MARK: - Method

    private func enqueue(_ operation: @escaping () async throws -> Void) async throws {
        let previousTask = lastTask
        let task = Task {
            _ = await previousTask?.result
            try await operation()
        }
        lastTask = task
        try await task.value
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
        try await enqueue { [service] in
            _ = try await service.register(request: request)
        }
    }

    func unregister() async throws {
        let installationID = installationIDStorage.installationID
        try await enqueue { [service] in
            try await service.unregister(installationId: installationID)
        }
    }
}
