//
//  OnboardingStatusStorage.swift
//  Nearby
//
//  Created by 신서연 on 10/21/26.
//

import Foundation

protocol OnboardingStatusStorage {
    var onboardingStatus: OnboardingStatus? { get }

    func save(_ status: OnboardingStatus)
    func clear()
}

final class UserDefaultsOnboardingStatusStorage: OnboardingStatusStorage {

    // MARK: - Properties

    private let userDefaults: UserDefaults
    private let key = "nearby.auth.onboardingStatus"

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Methods

    var onboardingStatus: OnboardingStatus? {
        guard let rawValue = userDefaults.string(forKey: key) else {
            return nil
        }

        return OnboardingStatus(rawValue: rawValue)
    }

    func save(_ status: OnboardingStatus) {
        userDefaults.set(status.rawValue, forKey: key)
    }

    func clear() {
        userDefaults.removeObject(forKey: key)
    }
}
