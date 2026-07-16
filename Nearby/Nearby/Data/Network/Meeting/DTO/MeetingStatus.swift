//
//  MeetingStatus.swift
//  Nearby
//
//  Created by h2e on 7/13/26.
//

enum MeetingStatus: String, Decodable {
    case ongoing = "ONGOING"
    case canceled = "CANCELED"
    case completed = "COMPLETED"
    case unknown

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = MeetingStatus(rawValue: rawValue) ?? .unknown
    }
}

enum MeetingProgressStatus: String, Decodable {
    case scheduling = "SCHEDULING"
    case ongoing = "ONGOING"
    case unknown

    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(String.self)
        self = MeetingProgressStatus(rawValue: rawValue) ?? .unknown
    }
}
