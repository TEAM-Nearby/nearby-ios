//
//  CompletedMeetingStorage.swift
//  Nearby
//
//  Created by h2e on 10/20/26.
//

import Foundation

protocol CompletedMeetingStorage {
    var completedMatchIDs: Set<Int> { get }
    func insert(matchID: Int)
}

final class UserDefaultsCompletedMeetingStorage: CompletedMeetingStorage {

    // MARK: - Properties

    private enum Key {
        static let completedMatchIDs = "nearby.meeting.completedMatchIDs"
    }

    private let userDefaults: UserDefaults
    private let tokenStorage: TokenStorage

    private var key: String {
        guard let userID = tokenStorage.currentUserId else { return Key.completedMatchIDs }
        return "\(Key.completedMatchIDs).\(userID)"
    }

    var completedMatchIDs: Set<Int> {
        Set(userDefaults.array(forKey: key) as? [Int] ?? [])
    }

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard, tokenStorage: TokenStorage) {
        self.userDefaults = userDefaults
        self.tokenStorage = tokenStorage
    }

    // MARK: - Method

    func insert(matchID: Int) {
        userDefaults.set(Array(completedMatchIDs.union([matchID])), forKey: key)
    }
}
