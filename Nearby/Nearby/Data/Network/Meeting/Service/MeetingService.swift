//
//  MeetingService.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

protocol MeetingService {
    func fetchMeetingList() async throws -> MeetingListResponseDTO
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetailResponseDTO
}

final class DefaultMeetingService {

    // MARK: - Property

    private let networkProvider: NetworkProvider

    // MARK: - Initializer

    init(networkProvider: NetworkProvider) {
        self.networkProvider = networkProvider
    }
}

// MARK: - MeetingService

extension DefaultMeetingService: MeetingService {
    func fetchMeetingList() async throws -> MeetingListResponseDTO {
        try await networkProvider.request(MeetingTarget.fetchMeetingList, responseType: MeetingListResponseDTO.self)
    }
    
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetailResponseDTO {
        try await networkProvider.request(MeetingTarget.fetchMeetingDetail(meetingId: meetingId), responseType: MeetingDetailResponseDTO.self)
    }
}
