//
//  MeetingRepository.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

protocol MeetingRepository {
    func fetchMeetingList() async throws -> [MeetingResponseDTO]
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetailResponseDTO
}

final class DefaultMeetingRepository {
    
    // MARK: - Property
    
    private let meetingService: MeetingService
    
    // MARK: - Initializer
    
    init(meetingService: MeetingService) {
        self.meetingService = meetingService
    }
}

// MARK: - MeetingRepository

extension DefaultMeetingRepository: MeetingRepository {
    func fetchMeetingList() async throws -> [MeetingResponseDTO] {
        try await meetingService.fetchMeetingList().meetings
    }
    
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetailResponseDTO {
        try await meetingService.fetchMeetingDetail(meetingId: meetingId)
    }
}
