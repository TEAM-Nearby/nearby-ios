//
//  InstallationIDStorage.swift
//  Nearby
//
//  Created by h2e on 10/12/26.
//

import Foundation

protocol InstallationIDStorage {
    var installationID: String { get }
}

final class UserDefaultsInstallationIDStorage: InstallationIDStorage {

    // MARK: - Properties

    private enum Key {
        static let installationID = "nearby.push.installationID"
    }

    var installationID: String {
        if let storedID = userDefaults.string(forKey: Key.installationID) {
            return storedID
        }
        let newID = UUID().uuidString
        userDefaults.set(newID, forKey: Key.installationID)
        return newID
    }

    private let userDefaults: UserDefaults

    // MARK: - Initializer

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
}
