//
//  MeetingEventCenter.swift
//  Nearby
//
//  Created by h2e on 7/17/26.
//

import Combine

final class MeetingEventCenter {

    // MARK: - Properties

    let meetingCompleted = PassthroughSubject<Int, Never>()

    private let storage: CompletedMeetingStorage

    var completedMatchIds: Set<Int> {
        storage.completedMatchIDs
    }

    // MARK: - Initializer

    init(storage: CompletedMeetingStorage) {
        self.storage = storage
    }

    // MARK: - Method

    func notifyCompleted(matchId: Int) {
        storage.insert(matchID: matchId)
        meetingCompleted.send(matchId)
    }
}
