//
//  NetworkProviding.swift
//  Nearby
//
//  Created by soomin on 9/17/26.
//

@MainActor
protocol NetworkProviding {
    func request<T: Decodable>(_ target: BaseTargetType, responseType: T.Type) async throws -> T
    func requestEmpty(_ target: BaseTargetType) async throws
}
