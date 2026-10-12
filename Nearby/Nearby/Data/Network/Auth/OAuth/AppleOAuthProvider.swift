//
//  AppleOAuthProvider.swift
//  Nearby
//
//  Created by 신서연 on 10/2/26.
//

import AuthenticationServices
import CryptoKit
import Foundation
import UIKit

struct AppleCredential {

    // MARK: - Properties

    let identityToken: String
    let authorizationCode: String
    let nonce: String
}

enum AppleOAuthError: Error {
    case invalidCredential
    case missingIdentityToken
    case invalidIdentityToken
    case missingAuthorizationCode
    case invalidAuthorizationCode
    case missingNonce
}

protocol AppleOAuthProvider {
    func requestCredential() async throws -> AppleCredential
}

final class DefaultAppleOAuthProvider: NSObject {

    // MARK: - Property

    private var continuation: CheckedContinuation<AppleCredential, Error>?
    private var currentNonce: String?
}

extension DefaultAppleOAuthProvider: AppleOAuthProvider {
    func requestCredential() async throws -> AppleCredential {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            let nonce = UUID().uuidString
            currentNonce = nonce
            request.nonce = SHA256.hash(data: Data(nonce.utf8))
                .compactMap { String(format: "%02x", $0) }
                .joined()
            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(authorizationRequests: [request])

            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension DefaultAppleOAuthProvider: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(throwing: AppleOAuthError.invalidCredential)
            continuation = nil
            return
        }

        guard let identityTokenData = credential.identityToken else {
            continuation?.resume(throwing: AppleOAuthError.missingIdentityToken)
            continuation = nil
            return
        }

        guard let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleOAuthError.invalidIdentityToken)
            continuation = nil
            return
        }

        guard let authorizationCodeData = credential.authorizationCode else {
            continuation?.resume(throwing: AppleOAuthError.missingAuthorizationCode)
            continuation = nil
            return
        }

        guard let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            continuation?.resume(throwing: AppleOAuthError.invalidAuthorizationCode)
            continuation = nil
            return
        }
        
        guard let nonce = currentNonce else {
            continuation?.resume(
                throwing: AppleOAuthError.missingNonce
            )
            continuation = nil
            return
        }

        let appleCredential = AppleCredential(identityToken: identityToken, authorizationCode: authorizationCode, nonce: nonce)

        continuation?.resume(returning: appleCredential)
        continuation = nil
        currentNonce = nil
    }

    func authorizationController(
        controller: ASAuthorizationController, didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
        currentNonce = nil
    }
}

extension DefaultAppleOAuthProvider: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
              let window = windowScene.windows.first(where: \.isKeyWindow) else {
            return ASPresentationAnchor()
        }

        return window
    }
}
