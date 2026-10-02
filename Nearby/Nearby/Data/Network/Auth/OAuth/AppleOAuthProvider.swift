//
//  AppleOAuthProvider.swift
//  Nearby
//
//  Created by 신서연 on 10/2/26.
//

import AuthenticationServices
import Foundation

struct AppleCredential {

    // MARK: - Properties

    let identityToken: String
    let authorizationCode: String
}

enum AppleOAuthError: Error {
    case invalidCredential
    case missingIdentityToken
    case invalidIdentityToken
    case missingAuthorizationCode
    case invalidAuthorizationCode
}

protocol AppleOAuthProvider {
    func requestCredential() async throws -> AppleCredential
}

final class DefaultAppleOAuthProvider: NSObject {

    // MARK: - Property

    private var continuation: CheckedContinuation<AppleCredential, Error>?
}

extension DefaultAppleOAuthProvider: AppleOAuthProvider {

    func requestCredential() async throws -> AppleCredential {
        try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation

            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()

            request.requestedScopes = [.fullName, .email]

            let authorizationController = ASAuthorizationController(
                authorizationRequests: [request]
            )

            authorizationController.delegate = self
            authorizationController.performRequests()
        }
    }
}

extension DefaultAppleOAuthProvider: ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            continuation?.resume(
                throwing: AppleOAuthError.invalidCredential
            )
            continuation = nil
            return
        }

        guard let identityTokenData = credential.identityToken else {
            continuation?.resume(
                throwing: AppleOAuthError.missingIdentityToken
            )
            continuation = nil
            return
        }

        guard let identityToken = String(
            data: identityTokenData,
            encoding: .utf8
        ) else {
            continuation?.resume(
                throwing: AppleOAuthError.invalidIdentityToken
            )
            continuation = nil
            return
        }

        guard let authorizationCodeData = credential.authorizationCode else {
            continuation?.resume(
                throwing: AppleOAuthError.missingAuthorizationCode
            )
            continuation = nil
            return
        }

        guard let authorizationCode = String(
            data: authorizationCodeData,
            encoding: .utf8
        ) else {
            continuation?.resume(
                throwing: AppleOAuthError.invalidAuthorizationCode
            )
            continuation = nil
            return
        }

        let appleCredential = AppleCredential(
            identityToken: identityToken,
            authorizationCode: authorizationCode
        )

        continuation?.resume(returning: appleCredential)
        continuation = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        continuation?.resume(throwing: error)
        continuation = nil
    }
}
