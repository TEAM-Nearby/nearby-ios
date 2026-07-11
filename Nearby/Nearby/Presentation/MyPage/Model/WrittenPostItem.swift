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
    let latitude: Double
    let longitude: Double
    let placeID: String?

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
        latitude: Double,
        longitude: Double,
        placeID: String? = nil,
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
        self.latitude = latitude
        self.longitude = longitude
        self.placeID = placeID
        self.meetingDateText = meetingDateText
        self.currentPeopleCount = currentPeopleCount
        self.maximumPeopleCount = maximumPeopleCount
        self.content = content
        self.keywords = keywords
    }
}
