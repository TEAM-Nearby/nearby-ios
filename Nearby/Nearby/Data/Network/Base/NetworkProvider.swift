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
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ target: BaseTargetType,
        responseType: T.Type,
        accessToken: String? = nil
    ) async throws -> T {
        let response: BaseResponseDTO<T> = try await requestBaseResponse(
            target,
            responseType: responseType,
            accessToken: accessToken
        )
        
        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    func requestEmpty(
        _ target: BaseTargetType,
        accessToken: String? = nil
    ) async throws {
        _ = try await requestBaseResponse(
            target,
            responseType: EmptyResponse.self,
            accessToken: accessToken
        )
    }
}

private extension NetworkProvider {
    func requestBaseResponse<T: Decodable>(
        _ target: BaseTargetType,
        responseType: T.Type,
        accessToken: String?
    ) async throws -> BaseResponseDTO<T> {
        let urlRequest = try makeURLRequest(target: target, accessToken: accessToken)
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
        
        throw decodeErrorResponse(data: data, fallbackStatusCode: statusCode)
    }
    
    func makeURL(path: String) throws -> URL {
        guard let url = URL(string: path, relativeTo: try AppConfig.baseURL()) else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
    
    func makeURLRequest(target: BaseTargetType, accessToken: String?) throws -> URLRequest {
        let url = try makeURL(path: target.path)
        var request = URLRequest(url: url)
        request.method = target.method
        request.headers = target.makeHeaders(accessToken: accessToken)
        
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
}
