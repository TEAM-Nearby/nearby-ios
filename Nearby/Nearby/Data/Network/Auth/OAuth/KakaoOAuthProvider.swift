//
//  KakaoOAuthProvider.swift
//  Nearby
//
//  Created by soomin on 7/12/26.
//

import Foundation

import KakaoSDKAuth
import KakaoSDKUser

struct KakaoCredential {
    let idToken: String
    let nonce: String
}

enum KakaoOAuthError: Error { case missingIDToken }

protocol KakaoOAuthProvider {
    func requestCredential() async throws -> KakaoCredential
}

final class DefaultKakaoOAuthProvider: KakaoOAuthProvider {
    func requestCredential() async throws -> KakaoCredential {
        let nonce = UUID().uuidString
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount(nonce: nonce) { token, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let idToken = token?.idToken else {
                    continuation.resume(throwing: KakaoOAuthError.missingIDToken)
                    return
                }
                continuation.resume(returning: KakaoCredential(idToken: idToken, nonce: nonce))
            }
        }
    }
}
