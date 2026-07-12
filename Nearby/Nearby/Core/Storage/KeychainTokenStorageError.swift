//
//  KeychainTokenStorageError.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

enum KeychainTokenStorageError: Error {
    case unhandledStatus(OSStatus)
    case invalidData
}
