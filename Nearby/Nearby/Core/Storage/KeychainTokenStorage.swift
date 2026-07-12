//
//  KeychainTokenStorage.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation
import Security

final class KeychainTokenStorage {
    private enum Key {
        static let accessToken = "nearby.auth.accessToken"
        static let refreshToken = "nearby.auth.refreshToken"
    }

    // MARK: - Property

    private let service: String

    // MARK: - Initializer

    init(service: String = Bundle.main.bundleIdentifier ?? "com.dewby.Nearby") {
        self.service = service
    }
}

// MARK: - TokenStorage

extension KeychainTokenStorage: TokenStorage {

    // MARK: - Properties

    var accessToken: String? { try? read(for: Key.accessToken) }
    var refreshToken: String? { try? read(for: Key.refreshToken) }

    // MARK: - Methods

    func save(accessToken: String, refreshToken: String) throws {
        try save(accessToken, for: Key.accessToken)
        try save(refreshToken, for: Key.refreshToken)
    }

    func clear() throws {
        try delete(for: Key.accessToken)
        try delete(for: Key.refreshToken)
    }

    func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }

    func save(_ value: String, for key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainTokenStorageError.invalidData
        }
        let query = baseQuery(for: key)
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

        if status == errSecItemNotFound {
            var addQuery = query
            attributes.forEach { addQuery[$0.key] = $0.value }
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)

            if addStatus == errSecDuplicateItem {
                let retryStatus = SecItemUpdate(
                    query as CFDictionary,
                    attributes as CFDictionary
                )
                guard retryStatus == errSecSuccess else {
                    throw KeychainTokenStorageError.unhandledStatus(retryStatus)
                }
                return
            }

            guard addStatus == errSecSuccess else {
                throw KeychainTokenStorageError.unhandledStatus(addStatus)
            }
            return
        }
        guard status == errSecSuccess else {
            throw KeychainTokenStorageError.unhandledStatus(status)
        }
    }

    func read(for key: String) throws -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        if status == errSecItemNotFound { return nil }
        guard status == errSecSuccess else {
            throw KeychainTokenStorageError.unhandledStatus(status)
        }
        guard let data = item as? Data,
              let value = String(data: data, encoding: .utf8) else {
            throw KeychainTokenStorageError.invalidData
        }
        return value
    }

    func delete(for key: String) throws {
        let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainTokenStorageError.unhandledStatus(status)
        }
    }
}
