//
//  MyPageRepository.swift
//  Nearby
//
//  Created by 신서연 on 7/14/26.
//

protocol MyPageRepository {
    func fetchMyPage() async throws -> MyPageResponseDTO
}

final class DefaultMyPageRepository {

    // MARK: - Properties

    private let service: MyPageService

    // MARK: - Initializer

    init(service: MyPageService) {
        self.service = service
    }
}

// MARK: - MyPageRepository

extension DefaultMyPageRepository: MyPageRepository {

    func fetchMyPage() async throws -> MyPageResponseDTO {
        try await service.fetchMyPage()
    }
}
