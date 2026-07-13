//
//  MyPageService.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

protocol MyPageService {
    func fetchMyPage() async throws -> MyPageResponseDTO
}

final class DefaultMyPageService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - MyPageService

extension DefaultMyPageService: MyPageService {

    func fetchMyPage() async throws -> MyPageResponseDTO {
        try await networkProvider.request(MyPageTarget.fetchMyPage, responseType: MyPageResponseDTO.self)
    }
}
