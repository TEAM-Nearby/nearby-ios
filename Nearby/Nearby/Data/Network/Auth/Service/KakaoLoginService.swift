//
//  KakaoLoginService.swift
//  Nearby
//
//  Created by 신서연 on 7/8/26.
//

import Foundation

import KakaoSDKUser
internal import KakaoSDKAuth

struct KakaoLoginRequestDTO: Encodable {
    let idToken: String
    let nonce: String
}

struct KakaoLoginResponseDTO: Decodable {
    let status: Int
    let code: String
    let message: String
    let data: KakaoLoginDataDTO
}

struct KakaoLoginDataDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let accessTokenExpiresIn: Int
    let refreshTokenExpiresIn: Int
    let userId: Int
    let onboardingStatus: OnboardingStatus
}

enum OnboardingStatus: String, Decodable {
    case started = "STARTED"
    case phoneVerified = "PHONE_VERIFIED"
    case completed = "COMPLETED"
}

enum KakaoLoginError: Error {
    case missingIDToken
    case invalidURL
    case invalidResponse
}

final class KakaoAuthService {
    
    // MARK: - Properties
    
    private let baseURL = "https:// 어쩌구.. base url"
    
    // MARK: - Method
    
    func loginWithKakaoAccount(
        completion: @escaping (Result<KakaoLoginDataDTO, Error>) -> Void
    ) {
        let nonce = UUID().uuidString
        
        UserApi.shared.loginWithKakaoAccount(nonce: nonce) { [weak self] oauthToken, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let idToken = oauthToken?.idToken else {
                completion(.failure(KakaoLoginError.missingIDToken))
                return
            }
            
            self?.requestKakaoLogin(idToken: idToken, nonce: nonce, completion: completion)
        }
    }
}

// MARK: - Private Method

private extension KakaoAuthService {
    
    func requestKakaoLogin(
        idToken: String, nonce: String,
        completion: @escaping (Result<KakaoLoginDataDTO, Error>) -> Void
    ) {
        guard let url = URL(string: "\(baseURL)/auth/kakao/login") else {
            completion(.failure(KakaoLoginError.invalidURL))
            return
        }
        
        let requestDTO = KakaoLoginRequestDTO(idToken: idToken, nonce: nonce)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(requestDTO)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  let data else {
                DispatchQueue.main.async {
                    completion(.failure(KakaoLoginError.invalidResponse))
                }
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(KakaoLoginError.invalidResponse))
                }
                return
            }
            
            do {
                let responseDTO = try JSONDecoder().decode(
                    KakaoLoginResponseDTO.self, from: data
                )
                
                DispatchQueue.main.async {
                    completion(.success(responseDTO.data))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
