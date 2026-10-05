//
//  AppIntroductionStorage.swift
//  Nearby
//
//  Created by soomin on 10/2/26.
//

import Foundation

protocol AppIntroductionStorage {
    var hasCompletedAppIntroduction: Bool { get }
    func markAppIntroductionAsCompleted()
}

final class UserDefaultsAppIntroductionStorage: AppIntroductionStorage {

    // MARK: - Properties

    private enum Key {
        static let hasCompletedAppIntroduction = "nearby.appIntroduction.hasCompleted"
    }
    
    var hasCompletedAppIntroduction: Bool {
        userDefaults.bool(forKey: Key.hasCompletedAppIntroduction)
    }

    private let userDefaults: UserDefaults

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Method

    func markAppIntroductionAsCompleted() {
        userDefaults.set(true, forKey: Key.hasCompletedAppIntroduction)
    }
}
