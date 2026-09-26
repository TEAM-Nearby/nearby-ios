//
//  MeetingRepository.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

import Foundation

protocol MeetingRepository {
    func fetchMeetingList() async throws -> [Meeting]
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetail
    func checkIn(meetingId: Int, latitude: Double, longitude: Double) async throws
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
    func fetchMeetingList() async throws -> [Meeting] {
        try await meetingService.fetchMeetingList().meetings.map(MeetingMapper.map)
    }
    
    func fetchMeetingDetail(meetingId: Int) async throws -> MeetingDetail {
        let response = try await meetingService.fetchMeetingDetail(meetingId: meetingId)
        return MeetingMapper.map(response)
    }
    
    func checkIn(meetingId: Int, latitude: Double, longitude: Double) async throws {
        _ = try await meetingService.checkIn(meetingId: meetingId, latitude: latitude, longitude: longitude)
    }
}
