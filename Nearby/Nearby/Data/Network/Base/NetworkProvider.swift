//
//  NetworkProvider.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import Alamofire
import Foundation

final class NetworkProvider {
    private let session: Session
    private let tokenStorage: TokenStorage
    private var refreshTask: Task<Void, Error>?
    
    init(session: Session = .default, tokenStorage: TokenStorage) {
        self.session = session
        self.tokenStorage = tokenStorage
    }
    
    func request<T: Decodable>(_ target: BaseTargetType, responseType: T.Type) async throws -> T {
        let response: BaseResponseDTO<T> = try await requestBaseResponse(
            target,
            responseType: responseType,
            canRefreshToken: true
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    func requestEmpty(_ target: BaseTargetType) async throws {
        _ = try await requestBaseResponse(
            target,
            responseType: EmptyResponse.self,
            canRefreshToken: true
        )
    }
}

private extension NetworkProvider {
    func requestBaseResponse<T: Decodable>(_ target: BaseTargetType, responseType: T.Type, canRefreshToken: Bool) async throws -> BaseResponseDTO<T> {
        let urlRequest = try makeURLRequest(target: target)
        let dataResponse = await session.request(
            urlRequest
        )
            .serializingData()
            .response
        
        if let error = dataResponse.error {
            throw mapAFError(error)
        }
        
        guard let statusCode = dataResponse.response?.statusCode else {
            throw NetworkError.unknown
        }
        
        guard let data = dataResponse.data else {
            throw NetworkError.decoding
        }
        
        if (200..<300).contains(statusCode) {
            do {
                return try JSONDecoder().decode(BaseResponseDTO<T>.self, from: data)
            } catch {
                AppLogger.error(error)
                throw NetworkError.decoding
            }
        }
        
        let error = decodeErrorResponse(data: data, fallbackStatusCode: statusCode)

        if canRefreshToken, target.requiresAuth, shouldRefreshToken(for: error) {
            try await refreshTokens()
            return try await requestBaseResponse(
                target,
                responseType: responseType,
                canRefreshToken: false
            )
        }

        if shouldInvalidateSession(for: error) {
            invalidateSession()
        }
        throw error
    }
    
    func makeURL(path: String) throws -> URL {
        guard let url = URL(string: path, relativeTo: try AppConfig.baseURL()) else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func makeURLRequest(target: BaseTargetType) throws -> URLRequest {
        let url = try makeURL(path: target.path)
        var request = URLRequest(url: url)
        request.method = target.method
        request.headers = target.makeHeaders(
            accessToken: target.requiresAuth ? tokenStorage.accessToken : nil
        )
        
        if let queryParameters = target.queryParameters {
            request = try URLEncoding.queryString.encode(request, with: queryParameters)
        }
        
        if let bodyParameters = target.bodyParameters {
            request = try JSONEncoding.default.encode(request, with: bodyParameters)
        }
        
        return request
    }
    
    func mapAFError(_ error: AFError) -> NetworkError {
        if let urlError = error.underlyingError as? URLError, urlError.code == .timedOut {
            return .timeout
        }
        
        if error.localizedDescription.lowercased().contains("timed out") {
            return .timeout
        }
        
        if error.isSessionTaskError {
            return .networkFail
        }
        
        if error.isResponseSerializationError {
            return .decoding
        }
        
        return .unknown
    }
    
    func decodeErrorResponse(data: Data, fallbackStatusCode: Int) -> NetworkError {
        do {
            let response = try JSONDecoder().decode(BaseResponseDTO<EmptyResponse>.self, from: data)
            return NetworkError.mapped(
                status: response.status,
                code: response.code,
                message: response.message
            )
        } catch {
            AppLogger.error(error)
            return .serverError(
                status: fallbackStatusCode,
                code: "UNKNOWN_ERROR",
                message: "알 수 없는 오류가 발생했습니다."
            )
        }
    }

    func shouldRefreshToken(for error: NetworkError) -> Bool {
        guard case .unauthorized(let code, _) = error else { return false }
        return ["TOKEN_EXPIRED", "ACCESS_TOKEN_EXPIRED"].contains(code)
    }

    func shouldInvalidateSession(for error: NetworkError) -> Bool {
        switch error {
        case .unauthorized(let code, _):
            return ["INVALID_TOKEN", "INVALID_REFRESH_TOKEN"].contains(code)
        case .conflict(let code, _):
            return code == "REFRESH_TOKEN_ALREADY_REVOKED"
        case .badRequest(let code, _):
            return code == "INVALID_TOKEN_REFRESH_REQUEST"
        default:
            return false
        }
    }

    func refreshTokens() async throws {
        if let refreshTask {
            return try await refreshTask.value
        }

        let task = Task { [weak self] in
            guard let self else { throw NetworkError.unknown }
            guard let refreshToken = tokenStorage.refreshToken, !refreshToken.isEmpty else {
                throw NetworkError.unauthorized(code: "MISSING_REFRESH_TOKEN", message: "리프레시 토큰이 없습니다.")
            }
            let response: BaseResponseDTO<TokenRefreshResponseDTO> = try await requestBaseResponse(
                AuthTarget.refresh(TokenRefreshRequestDTO(refreshToken: refreshToken)),
                responseType: TokenRefreshResponseDTO.self,
                canRefreshToken: false
            )
            guard let tokens = response.data else { throw NetworkError.decoding }
            try tokenStorage.save(
                accessToken: tokens.accessToken,
                refreshToken: tokens.refreshToken
            )
        }

        refreshTask = task
        defer { refreshTask = nil }

        do {
            try await task.value
        } catch {
            invalidateSession()
            throw error
        }
    }

    func invalidateSession() {
        try? tokenStorage.clear()
        NotificationCenter.default.post(name: .authenticationExpired, object: nil)
    }
}

extension Notification.Name {
    static let authenticationExpired = Notification.Name("authenticationExpired")
}
