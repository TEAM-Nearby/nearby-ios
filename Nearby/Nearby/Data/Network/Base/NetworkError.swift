//
//  NetworkError.swift
//  Nearby
//
//  Created by soomin on 7/5/26.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case networkFail
    case timeout
    case decoding
    case badRequest(code: String, message: String)
    case unauthorized(code: String, message: String)
    case forbidden(code: String, message: String)
    case notFound(code: String, message: String)
    case conflict(code: String, message: String)
    case gone(code: String, message: String)
    case badGateway(code: String, message: String)
    case internalServerError(code: String, message: String)
    case serverError(status: Int, code: String, message: String)
    case unknown
}

extension NetworkError {
    static func mapped(status: Int, code: String, message: String) -> NetworkError {
        switch status {
        case 400:
            return .badRequest(code: code, message: message)
        case 401:
            return .unauthorized(code: code, message: message)
        case 403:
            return .forbidden(code: code, message: message)
        case 404:
            return .notFound(code: code, message: message)
        case 409:
            return .conflict(code: code, message: message)
        case 410:
            return .gone(code: code, message: message)
        case 502:
            return .badGateway(code: code, message: message)
        case 500...599:
            return .internalServerError(code: code, message: message)
        default:
            return .serverError(status: status, code: code, message: message)
        }
    }

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .networkFail:
            return "네트워크 연결에 실패했습니다."
        case .timeout:
            return "요청 시간이 초과되었습니다."
        case .decoding:
            return "응답 데이터를 변환하지 못했습니다."
        case .badRequest(_, let message),
             .unauthorized(_, let message),
             .forbidden(_, let message),
             .notFound(_, let message),
             .conflict(_, let message),
             .gone(_, let message),
             .badGateway(_, let message),
             .internalServerError(_, let message),
             .serverError(_, _, let message):
            return message
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }

    var asAppError: AppError {
        switch self {
        case .badRequest:
            return .badRequest
        case .unauthorized(let code, let message):
            return unauthorizedAppError(code: code, message: message)
        case .notFound:
            return .notFound
        case .internalServerError:
            return .internalServerError
        case .networkFail, .timeout:
            return .networkFail
        case .decoding:
            return .decodingError
        case .invalidURL, .unknown:
            return .networkFail
        case .forbidden(_, let message),
             .conflict(_, let message),
             .gone(_, let message),
             .badGateway(_, let message),
             .serverError(_, _, let message):
            return .apiError(message: message)
        }
    }

    private func unauthorizedAppError(code: String, message: String) -> AppError {
        switch code {
        case "INVALID_TOKEN", "INVALID_REFRESH_TOKEN":
            return .invalidToken
        case "TOKEN_EXPIRED", "ACCESS_TOKEN_EXPIRED":
            return .tokenExpired
        case "KAKAO_LOGIN_FAILED":
            return .kakaoOAuthError
        default:
            return message.isEmpty ? .unauthorized : .apiError(message: message)
        }
    }
}
