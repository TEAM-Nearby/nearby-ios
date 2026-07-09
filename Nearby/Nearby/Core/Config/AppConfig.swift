//
//  AppConfig.swift
//  Nearby
//
//  Created by soomin on 7/3/26.
//

import Foundation

enum AppConfig {
    static func baseURL() throws -> URL {
        try url(forKey: "BASE_URL")
    }
    
    static func googleMapsAPIKey() throws -> String {
        try string(forKey: "GOOGLE_MAPS_API_KEY")
    }
    
    static func kakaoAPIKey() throws -> String {
        try string(forKey: "KAKAO_APP_KEY")
    }
}

private extension AppConfig {
    static func string(forKey key: String) throws -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty,
              !value.hasPrefix("$(") else {
            let error = AppError.missingConfig(key: key)
            AppLogger.error(error)
            throw error
        }
        
        return value
    }
    
    static func url(forKey key: String) throws -> URL {
        let stringValue = try string(forKey: key)
        
        guard let url = URL(string: stringValue) else {
            let error = AppError.missingConfig(key: key)
            AppLogger.error(error)
            throw error
        }
        
        return url
    }
}
