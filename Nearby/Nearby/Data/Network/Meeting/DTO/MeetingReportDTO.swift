//
//  MeetingReportDTO.swift
//  Nearby
//
//  Created by h2e on 10/9/26.
//

struct CreateMeetingReportRequestDTO {
    let reportedUserId: Int?
    let reasons: [String]
    let detail: String?
}

struct CreateMeetingReportResponseDTO: Decodable {
    let meetingId: Int
    let reportId: Int
    let reportedAt: String
}

struct CreateMatchReportResponseDTO: Decodable {
    let matchId: Int
    let reportId: Int
    let reportedAt: String
}
