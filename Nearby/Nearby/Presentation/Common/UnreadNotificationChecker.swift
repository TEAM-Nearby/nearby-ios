//
//  UnreadNotificationChecker.swift
//  Nearby
//
//  Created by h2e on 10/29/26.
//

import Foundation

final class UnreadNotificationChecker {

    // MARK: - Properties

    private static let retryDelays: [Duration] = [.seconds(3), .seconds(10)]

    private let repository: CompanionRequestRepository

    // MARK: - Initializer

    init(repository: CompanionRequestRepository) {
        self.repository = repository
    }

    // MARK: - Methods

    private func fetchHasUnread(direction: CompanionRequestDirection) async -> Bool? {
        do {
            let response = try await repository.fetchRequests(direction: direction)
            return response.requests.contains { !$0.isRead }
        } catch {
            guard !Task.isCancelled else { return nil }
            AppLogger.error(error)
            return nil
        }
    }

    func hasUnread() async -> Bool? {
        for retryIndex in 0...Self.retryDelays.count {
            async let sent = fetchHasUnread(direction: .sent)
            async let received = fetchHasUnread(direction: .received)
            let results = await (sent, received)
            guard !Task.isCancelled else { return nil }
            if results.0 == true || results.1 == true { return true }
            if results.0 == false, results.1 == false { return false }
            guard retryIndex < Self.retryDelays.count else { return nil }
            try? await Task.sleep(for: Self.retryDelays[retryIndex])
            guard !Task.isCancelled else { return nil }
        }
        return nil
    }
}
