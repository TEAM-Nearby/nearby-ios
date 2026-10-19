//
//  CompanionRequestRepository.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

import Foundation

protocol CompanionRequestRepository {
    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO
    func markNotificationAsRead(notificationId: Int) async throws -> CompanionNotificationReadResponseDTO
}

final class DefaultCompanionRequestRepository {

    // MARK: - Property

    private let service: CompanionRequestService

    // MARK: - Initializer

    init(service: CompanionRequestService) {
        self.service = service
    }
}

// MARK: - CompanionRequestRepository

extension DefaultCompanionRequestRepository: CompanionRequestRepository {

    func fetchRequests(direction: CompanionRequestDirection) async throws -> CompanionRequestListResponseDTO {
        try await service.fetchRequests(direction: direction)
    }

    func markNotificationAsRead(notificationId: Int) async throws -> CompanionNotificationReadResponseDTO {
        let response = try await service.markNotificationAsRead(notificationId: notificationId)
        if response.isRead {
            NotificationCenter.default.post(name: .companionNotificationDidChange, object: nil)
        }
        return response
    }
}

// MARK: - Notification.Name

extension Notification.Name {
    static let companionNotificationDidChange = Notification.Name("companionNotificationDidChange")
}
