//
//  MeetingEventCenter.swift
//  Nearby
//
//  Created by h2e on 7/17/26.
//

import Combine

final class MeetingEventCenter {
    let meetingCompleted = PassthroughSubject<Int, Never>()

    private(set) var completedMatchIds = Set<Int>()

    func notifyCompleted(matchId: Int) {
        completedMatchIds.insert(matchId)
        meetingCompleted.send(matchId)
    }
}
