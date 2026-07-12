//
//  TokenStorage.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

protocol TokenStorage {
    var accessToken: String? { get }
    var refreshToken: String? { get }

    func save(accessToken: String, refreshToken: String) throws
    func clear() throws
}
