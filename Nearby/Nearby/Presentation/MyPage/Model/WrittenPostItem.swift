//
//  WrittenPostItem.swift
//  Nearby
//
//  Created by 신서연 on 7/11/26.
//

import Foundation

struct WrittenPostItem {

    // MARK: - Properties

    let id: UUID
    let cityName: String
    let createdDateText: String
    let placeName: String
    let meetingDateText: String
    let currentPeopleCount: Int
    let maximumPeopleCount: Int
    let content: String
    let keywords: [String]

    // MARK: - Initializer

    init(
        id: UUID = UUID(),
        cityName: String,
        createdDateText: String,
        placeName: String,
        meetingDateText: String,
        currentPeopleCount: Int,
        maximumPeopleCount: Int,
        content: String,
        keywords: [String]
    ) {
        self.id = id
        self.cityName = cityName
        self.createdDateText = createdDateText
        self.placeName = placeName
        self.meetingDateText = meetingDateText
        self.currentPeopleCount = currentPeopleCount
        self.maximumPeopleCount = maximumPeopleCount
        self.content = content
        self.keywords = keywords
    }
}
